namespace :gen_forecasts do
  @shift_days = 5 * 365 + 84

  desc "Generates 7 day-ahead and one week-ahead forecasts from texas data"
  task :texas, [:provider_name, :directory] => :environment do |task, args|
    provider = ForecastProvider.where(name: args.provider_name)
      .first_or_create(name: args.provider_name, label: "provider_name")

    directory = args.directory
    puts("Loading files from #{directory}...")

    week_begins_at_dt = Time.parse("2012-12-02 05:00:00+00")
    week_end_at_dt = Time.parse("2012-12-09 04:00:00+00")
    weeks_loaded = 0
    days_loaded = 0

    files = Dir.glob("#{directory}/*.json")
    files.each do |f|
      json = JSON.parse(File.read(f))

      forecast_params = json['forecast']
        .transform_keys {|key|
          case key
          when 'provider_id' then 'forecast_provider_id'
          when 'provider_forecast_ref' then 'forecast_provider_forecast_ref'
          else
            key
          end
        }
        .tap {|p|
          if p.keys.include?('type')
            type_name = p.delete('type')
            forecast_type = ForecastType.where(name: type_name).first()
            p['forecast_type_id'] = forecast_type.id
          end
          if p.keys.include?('nrel_wtk_site_id')
            nrel_wtk_site_id = p.delete('nrel_wtk_site_id')
            farm = Farm.where(farm_provider_farm_ref: nrel_wtk_site_id.to_s).first()
            p['farm_id'] = farm.id
          end
          p['forecast_provider'] = provider
        }

        week_data = forecast_params['data']
        week_data = filter_data_by_datetime_range(week_data, week_begins_at_dt, week_end_at_dt)
        week_data = shift_data_to_begin_on_feb22(week_data)

        # calculate the shifted begins_at
        begins_at_dt = week_begins_at_dt - @shift_days.days

        # WEEK-AHEAD
        
        # calculate generated_at to be 2 hours before begins_at
        generated_at_dt = begins_at_dt - 2.hours

        week_ahead_params = forecast_params.merge({
          'begins_at' =>  begins_at_dt.iso8601,
          'data' =>  week_data,
          'generated_at' =>  generated_at_dt.iso8601,
          'horizon_minutes' =>  7 * 24 * 60
        })

        forecast = Forecast.new week_ahead_params
        if forecast.save then
          weeks_loaded += 1
        else
          puts "ERROR: #{forecast.errors.details}"
        end
        
        # DAY-AHEAD
        week_data.each_slice(24).reduce(0) {|day_acc, day_data|
          begins_at_ts = day_data[0][0]
          begins_at_dt = Time.parse(begins_at_ts)
          generated_at_dt = begins_at_dt - 2.hours

          day_ahead_params = forecast_params.merge({
            'begins_at' =>  begins_at_dt.iso8601,
            'data' =>  day_data,
            'generated_at' =>  generated_at_dt.iso8601,
            'forecast_provider_forecast_ref' =>  nil,
            'horizon_minutes' =>  24 * 60
          })

          forecast = Forecast.new day_ahead_params
          if forecast.save then
            days_loaded += 1
          else
            puts "ERROR: #{forecast.errors.details}"
          end
        }
    end

    puts("Loaded #{weeks_loaded} week-ahead forecasts and #{days_loaded} day-ahead forecasts from #{files.count} files.")
  end

  private

  def filter_data_by_datetime_range(data, begins_at, ends_at)
    data.select {|row|
        timestamp = Time.parse(row[0])
        timestamp.between? begins_at, ends_at
    }
  end

  def shift_data_to_begin_on_feb22(data)
    data.each {|row|
        timestamp = Time.parse(row[0])
        timestamp = timestamp + @shift_days.days
        row[0] = timestamp.iso8601
    }
  end
end
