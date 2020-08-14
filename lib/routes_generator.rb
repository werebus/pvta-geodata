# frozen_string_literal: true

class RoutesGenerator < Generator
  def features
    { type: 'FeatureCollection',
      features: @source.routes.map do |route|
        { type: 'Feature',
          id: route.id,
          properties: { short_name: route.short_name,
                        long_name: route.long_name },
          geometry: { type: 'GeometryCollection',
                      geometries: shape_collection(route.id) } }
      end }
  end

  private

  def shape_collection(route_id)
    shapes.map do |_shape_id, attributes|
      next unless attributes[:route] == route_id

      points = attributes[:points].sort_by { |pt| pt.pt_sequence.to_i }
      { type: 'LineString',
        coordinates: points.map { |point| [point.pt_lon.to_f, point.pt_lat.to_f] } }
    end.compact
  end

  def shapes
    return @shapes if @shapes

    shapes = Hash.new { |hash, key| hash[key] = { points: [] } }
    @source.shapes.each do |shape|
      shapes[shape.id][:points] << shape
    end

    @source.trips.each do |trip|
      shapes[trip.shape_id][:route] ||= trip.route_id
    end
    @shapes = shapes
  end
end
