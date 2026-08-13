# frozen_string_literal: true

require 'json'
require_relative 'missions'
require_relative 'videos'
require_relative 'articles'
require_relative 'events'

content = []

versions = VersionHelper::VERSIONS

versions.each do |version|
  next if version[:version] == 'Pre'

  content.concat(
    Missions.parse(
      version[:version],
      version[:start]
    )
  )
end

video_pages = {
  'A Moment Among the Stars': 35630,
  'Animated Short': 6609,
  'Character Trailer': 6020,
  'Extended Play': 36980
}


video_pages.each do |title, id|
  content.concat(
    Videos.parse(id, title)
  )
end

content.concat(
  Articles.parse('HoYoLAB/Articles')
)

content.concat(
  Events.parse('Conventional Memoir')
)

puts content.group_by { |item| item[:version] }
            .transform_values(&:count)

puts 'WRITING FILE NOW'
puts File.expand_path('../content.json')

File.write(
  'content.json',
  JSON.pretty_generate(content)
)

puts "Generated #{content.length} items"
