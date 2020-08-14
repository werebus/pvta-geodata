# frozen_string_literal: true

require 'net/http'
require 'uri'

class FeedZipFile
  attr_reader :path

  def initialize(url, path)
    @url = URI.parse(url)
    @path = path
  end

  def fetch!
    File.open(@path, 'wb') do |f|
      Net::HTTP.start(@url.host) do |h|
        resp = h.get(@url.path)
        f.write resp.body if resp.is_a? Net::HTTPSuccess
      end
    end
  end
end
