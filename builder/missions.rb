# frozen_string_literal: true

require_relative 'fandom_api'

class Missions
  TYPES = [
    'Trailblaze Missions',
    'Companion Missions',
    'Adventure Missions',
    'Event Missions',
    'Daily Missions'
  ].freeze

  def self.parse(version, date)
    sections = FandomApi.fetch(
      action: 'parse',
      page: "Version/#{version}",
      prop: 'sections'
    )

    unless sections['parse']
      puts "Failed parsing Version/#{version}"
      puts sections
      return []
    end

    indexes = sections['parse']['sections']
              .select { |s| TYPES.include?(s['line']) }
              .map { |s| [s['line'], s['index']] }

    missions = []

    indexes.each do |type, index|
      section = FandomApi.fetch(
        action: 'parse',
        page: "Version/#{version}",
        prop: 'wikitext',
        section: index
      )

      unless section['parse']
        puts "Failed parsing section #{type} in Version/#{version}"
        puts section
        next
      end

      text = section['parse']['wikitext']['*']

      text.each_line do |line|
        next unless line.match?(/^\* \[\[/)

        match = line.match(/\[\[(.*?)\]\]/)
        next unless match

        missions << {
          title: match[1].split('|').first,
          date: date,
          version: version,
          type: 'Mission',
          series: type.gsub(' Missions', '')
        }
      end
    end

    missions
  end
end
