# frozen_string_literal: true

require 'faraday'
require 'json'
require 'fileutils'
require 'open-uri'

class FandomApi
  BASE_URL = 'https://honkai-star-rail.fandom.com/api.php'

  CACHE_DIR = File.join(__dir__, 'cache')

  def self.fetch(options = {})
    FileUtils.mkdir_p(CACHE_DIR)

    cache_key = options.values.join('-')
                       .gsub(/[^0-9a-zA-Z_-]/, '_')

    cache_file = File.join(CACHE_DIR, "#{cache_key}.json")

    return JSON.parse(File.read(cache_file)) if File.exist?(cache_file)

    params = {
      format: 'json',
      origin: '*'
    }.merge(options)

    response = URI.open(
      "#{BASE_URL}?#{URI.encode_www_form(params)}"
    )

    data = JSON.parse(response.read)

    File.write(
      cache_file,
      JSON.pretty_generate(data)
    )

    data
  end
end
