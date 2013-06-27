require 'json'
require 'csv'

class ShapeParser
  def initialize(filename)
    @file = filename
    @lines = []
    @fields = {}
    @json = { 'type' => 'FeatureCollection',
              'crs'  => { 'type'       => 'name',
                          'properties' => { 'name' => 'urn:ogc:def:crs:OGC:1.3:CRS84' } },
              'features' => []
            }

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
        unless @json['features'].find {|feat| feat['id'] == row[@fields[:shape_id]] }
          @json['features'] << { 'type'       => 'Feature',
                                 'id'         => row[@fields[:shape_id]],
                                 'properties' => { 'id'          => row[@fields[:shape_id]] },
                                 'geometry'   => { 'type'        => 'LineString',
                                                   'coordinates' => [] }}
        end
        @lines << row
      end
    end
    @json['features'].each do |feat|
       $stderr.puts "Shape: #{feat['id']}" if ENV['DEBUG']
       feat['geometry']['coordinates'] = @lines.find_all { |row| row[@fields[:shape_id]] == feat['id'] }
                                               .sort_by  { |row| row[@fields[:shape_pt_sequence]] }
                                               .map      { |row| [ row[@fields[:shape_pt_lon]],row[@fields[:shape_pt_lat]] ] }
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
