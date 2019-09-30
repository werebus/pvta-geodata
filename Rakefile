# frozen_string_literal: true

require 'gtfs'
require 'json'
require 'net/http'
require 'rake/clean'

file 'gtfs.zip' do
  File.open('gtfs.zip', 'wb') do |f|
    Net::HTTP.start('pvta.com') do |h|
      resp = h.get('/g_trans/google_transit.zip')
      f.write resp.body if resp.is_a? Net::HTTPSuccess
    end
  end
end
CLEAN << 'gtfs.zip'

file 'pvta_stops.geojson' => 'gtfs.zip' do
  source = GTFS::Source.build('gtfs.zip')
  document =
    {
      type: 'GeometryCollection',
      geometries: source.stops.map do |stop|
        {
          type: 'Point',
          id: stop.id.to_i,
          coordinates: [stop.lon.to_f, stop.lat.to_f],
          properties: {
            code: stop.code,
            name: stop.name
          }
        }
      end
    }
  File.open('pvta_stops.geojson', 'w') do |f|
    f.write(JSON.generate(document))
    f.write("\n")
  end
end
CLOBBER << 'pvta_stops.geojson'

file 'pvta_routes.geojson' => 'gtfs.zip' do
  source = GTFS::Source.build('gtfs.zip')
  # { shape_id => { route: route_id, points: [] }
  shapes = Hash.new { |hash, key| hash[key] = { points: [] } }
  document =
    {
      type: 'FeatureCollection',
      features: []
    }
  source.shapes.each do |shape|
    shapes[shape.id][:points] << shape
  end
  source.trips.each do |trip|
    shapes[trip.shape_id][:route] ||= trip.route_id
  end
  source.routes.each do |route|
    document[:features] <<
      {
        type: 'Feature',
        geometry: {
          type: 'GeometryCollection',
          properties: {
            id: route.id,
            short_name: route.short_name,
            long_name: route.long_name
          },
          geometries: shapes.map do |shape_id, attributes|
            next unless attributes[:route] == route.id
            {
              type: 'LineString',
              coordinates: attributes[:points].sort_by { |point| point.pt_sequence.to_i }.map do |point|
                [point.pt_lon.to_f, point.pt_lat.to_f]
              end
            }
          end.compact
        }
      }
  end
  File.open('pvta_routes.geojson', 'w') do |f|
    f.write(JSON.generate(document))
    f.write("\n")
  end
end
CLOBBER << 'pvta_routes.geojson'
