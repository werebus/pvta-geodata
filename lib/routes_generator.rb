# frozen_string_literal: true

class RoutesGenerator < Generator
  def features
    # { shape_id => { route: route_id, points: [] }
    shapes = Hash.new { |hash, key| hash[key] = { points: [] } }
    document = { type: 'FeatureCollection', features: [] }

    @source.shapes.each do |shape|
      shapes[shape.id][:points] << shape
    end

    @source.trips.each do |trip|
      shapes[trip.shape_id][:route] ||= trip.route_id
    end

    @source.routes.each do |route|
      document[:features] <<
        {
          type: 'Feature',
          id: route.id,
          properties: {
            short_name: route.short_name,
            long_name: route.long_name
          },
          geometry: {
            type: 'GeometryCollection',
            geometries: shapes.map do |shape_id, attributes|
              next unless attributes[:route] == route.id
              {
                type: 'LineString',
                coordinates: attributes[:points].sort_by do |point|
                  point.pt_sequence.to_i 
                end.map do |point|
                  [point.pt_lon.to_f, point.pt_lat.to_f]
                end
              }
            end.compact
          }
        }
    end
    document
  end
end
