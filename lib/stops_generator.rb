# frozen_string_literal: true

class StopsGenerator < Generator
  def features
    { type: 'FeatureCollection',
      features: @source.stops.map do |stop|
        { type: 'Feature',
          id: stop.id.to_i,
          properties: { code: stop.code,
                        name: stop.name },
          geometry: { type: 'Point',
                      coordinates: [stop.lon.to_f, stop.lat.to_f] } }
      end }
  end
end
