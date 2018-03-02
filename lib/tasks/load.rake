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
  task :forecasts, [:provider_name, :directory] => :environment do |task, args|
    provider = ForecastProvider.where(name: args.provider_name)
      .first_or_create(name: args.provider_name, label: "provider_name")

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
          p['forecast_provider'] = provider
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
end
