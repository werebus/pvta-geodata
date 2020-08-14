# frozen_string_literal: true

require 'gtfs'
require 'json'

class Generator
  def initialize(source_file)
    @source = GTFS::Source.build(source_file)
  end

  def features
    raise NotImplementedError
  end

  def json
    JSON.generate(features) + "\n"
  end
end
