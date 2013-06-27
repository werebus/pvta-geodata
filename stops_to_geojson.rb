require 'json'
require 'csv'

json = { 'type' => 'FeatureCollection',
         'crs'  => { 'type'       => 'name',
                     'properties' => { 'name' => 'urn:ogc:def:crs:OGC:1.3:CRS84' } },
         'features' => []
       }

CSV.open('stops.txt', 'r') do |csv|
  fields = {}
  field_list = csv.shift
  field_list.each_with_index do |field, index|
    fields[field.to_sym] = index
  end

  csv.each do |row|
    json['features'] << { 'type'       => 'Feature',
                          'properties' => { 'id'          => row[fields[:stop_id]],
                                            'name'        => row[fields[:stop_name]] },
                          'geometry'   => { 'type'        => 'Point',
                                            'coordinates' => [ row[fields[:stop_lon]], row[fields[:stop_lat]] ] }}
  end
end

puts JSON.pretty_generate(json)
