require 'json'
require 'csv'

class StopParser
  def initialize(filename)
    @file = filename
    @json = { 'type' => 'FeatureCollection',
              'crs'  => { 'type'       => 'name',
                          'properties' => { 'name' => 'urn:ogc:def:crs:OGC:1.3:CRS84' } },
              'features' => []
            }
    @fields = {}

    CSV.open(@file, 'r') do |csv|
      field_list = csv.shift
      field_list.each_with_index do |field, index|
        @fields[field.to_sym] = index
      end
    end
  end

  def read_features
    CSV.open(@file, 'r') do |csv|
      csv.shift
      csv.each do |row|
        @json['features'] << { 'type'       => 'Feature',
                               'properties' => { 'id'          => row[@fields[:stop_id]],
                                                 'name'        => row[@fields[:stop_name]] },
                               'geometry'   => { 'type'        => 'Point',
                                                 'coordinates' => [ row[@fields[:stop_lon]], row[@fields[:stop_lat]] ] }}
      end
    end
  end

  def json(pretty = false)
    if pretty
      JSON.pretty_generate(@json)
    else
      JSON.generate(@json)
    end
  end
end
