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
      resp = Net::HTTP.get_response(@url)
      if resp.is_a? Net::HTTPSuccess
        f.write resp.body
      else
        File.unlink(@path)
        raise "Failed to fetch feed: #{resp.message}"
      end
    end
  end
end
