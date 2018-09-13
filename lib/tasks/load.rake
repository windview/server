namespace :load do
  desc "Load WIND Toolkit sites as farm from JSON"
  task :wtk_sites, [:filename] => :environment do |task, args|
    provider = FarmProvider.where(name: "windtoolkit")
      .first_or_create(name: "windtoolkit", label: "NREL WIND Toolkit")

    filename = args.filename
    puts("Loading sites from #{filename}...")

    json = JSON.parse(File.read(filename))

    count = 0
    json['features'].each do |f|
      site_id = f['properties']['site_id'].to_i.to_s.strip

      raw_coords = f['geometry']['coordinates']
      raw_coords = raw_coords[0] if raw_coords[0].is_a?(Array)
      long, lat = raw_coords

      farm = Farm.new name: "WIND Toolkit Site #{site_id}",
        farm_provider_id: provider.id,
        farm_provider_farm_ref: "#{site_id}",
        longitude: long,
        latitude: lat,
        capacity_mw: f['properties']['capacity']

      if farm.save
        count += 1
      else
        puts "ERROR: #{farm.errors.details}"
      end
    end

    puts "Loaded #{count} of #{json['features'].count} sites"
  end


  desc "Loads forecast with given provider from JSON file in directory."
  task :forecasts, [:farm_provider_name, :forecast_provider_name, :directory] => :environment do |task, args|
    farm_provider = FarmProvider.where(name: args.farm_provider_name).first
    forecast_provider = ForecastProvider.where(name: args.forecast_provider_name)
      .first_or_create(name: args.forecast_provider_name, label: "provider_name")

    directory = args.directory
    puts("Loading files from #{directory}...")

    forecast_count = 0
    files = Dir.glob("#{directory}/*.json")
    files.each do |f|
      json = JSON.parse(File.read(f))

      attrs = json['forecast']
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
          if farm_provider && p.keys.include?('farm_provider_farm_ref')
            provider_farm = farm_provider.farms.where(farm_provider_farm_ref: p.delete('farm_provider_farm_ref')).first()
            if (provider_farm)
              p['farm_id'] = provider_farm.id
            end
          end
          p['forecast_provider'] = forecast_provider
        }

      forecast = Forecast.new attrs

      if forecast.save
        forecast_count += 1
      else
        puts "ERROR: #{forecast.errors.details}"
      end
    end

    puts("Loaded #{forecast_count} forecasts from #{files.count} files.")
  end

  desc "Loads Texas sample data, modified for our demo purposes."
  task :texas, [:farm_provider_name, :forecast_provider_name, :directory] => :environment do |task, args|
    # to get to forecasts to appear for 2/22/2018
    shift_days = 5 * 365 + 83
    shift_seconds = shift_days * 24 * 60 * 60

    provider_name = 'argusprima'
    directory = './examples/argus_prima-wtk_texas_under_10mw/forecasts'

    farm_provider = FarmProvider.where(name: args.farm_provider_name).first
    forecast_provider = ForecastProvider.where(name: provider_name)
      .first_or_create(name: provider_name, label: "provider_name")

    # the week of data we are interested in
    week_begins_at = Time.parse("2012-12-02 05:00:00+00")
    week_ends_at = Time.parse("2012-12-09 04:00:00+00")

    puts("Loading texas files from #{directory}...")

    forecast_count = 0
    files = Dir.glob("#{directory}/*.json")
    files.each do |f|
      json = JSON.parse(File.read(f))

      attrs = json['forecast']
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
          if p.keys.include?('farm_provider_farm_ref')
            provider_farm = farm_provider.farms.where(farm_provider_farm_ref: p.delete('farm_provider_farm_ref')).first()
            if (provider_farm)
              p['farm_id'] = provider_farm.id
            end
          end
          p['forecast_provider'] = forecast_provider
        }

      week_data = filter_data_by_datetime_range(attrs['data'], week_begins_at, week_ends_at)
      week_data = shift_data_to_begin_on_feb22(week_data, shift_seconds)

      # calculate the shifted begins_at
      begins_at = week_begins_at + shift_seconds

      # calculate generated_at to be 2 hours before begins_at
      generated_at = begins_at - 2 * 60

      # LOAD SINGLE WEEK-AHEAD FORECAST
      forecast = Forecast.new attrs.merge({
          begins_at: begins_at.iso8601,
          generated_at: generated_at.iso8601,
          data: week_data,
          horizon_minutes: 7 * 24 * 60 * 60
      })

      if forecast.save
        forecast_count += 1
      else
        puts "ERROR: #{forecast.errors.details}"
      end


      # LOAD DAY-AHEAD FOR EACH DAY OF WEEK
      week_data.each_slice(24) { |day_data|
        begins_at = Time.parse(day_data[0][0])
        generated_at = begins_at - 2 * 60 * 60

        forecast = Forecast.new attrs.merge({
            begins_at: begins_at.iso8601,
            generated_at: generated_at.iso8601,
            data: day_data,
            forecast_provider_forecast_ref: nil,
            horizon_minutes: 24 * 60
        })

        if forecast.save
          forecast_count += 1
        else
          puts "ERROR: #{forecast.errors.details}"
        end
      }
    end

    puts("Loaded #{forecast_count} forecasts from #{files.count} files.")
  end
  
  def filter_data_by_datetime_range(data, begins_at, end_at)
    data.select {|row|
      ts = Time.parse(row[0])
      ts >= begins_at && ts <= end_at
    }
  end

  def shift_data_to_begin_on_feb22(data, shift_seconds)
    data.map { |row|
      row[0] = (Time.parse(row[0]) + shift_seconds).iso8601
      row
    }
  end

  desc "Transform texas"
  task :transform_texas => :environment do |task, args|
    directory = './examples/argus_prima-wtk_texas_under_10mw/forecasts'

    puts("Processing texas files from #{directory}...")

    files = Dir.glob("#{directory}/*.json")
    files.each do |f|
      json = JSON.parse(File.read(f))

      new_json = json['forecast']
        .tap {|p|
          if p.keys.include?('nrel_wtk_site_id')
            p['farm_provider_farm_ref'] = p.delete('nrel_wtk_site_id').to_s
          end
          if p.keys.include?('farm_id')
            p.delete('farm_id')
          end

          p['provider_id'] = 2
        }

      to_file = f.sub('/forecasts/', '/forecasts_xform/')
      File.open("#{to_file}", 'w') do |o|
        o.write((JSON.pretty_generate({ forecast: new_json })))
      end
    end

    puts("Transformed #{files.count} files.")
  end

end
