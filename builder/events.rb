# frozen_string_literal: true

require 'nokogiri'
require 'date'

require_relative 'fandom_api'
require_relative 'version_helper'

class Events
  def self.parse(page)
    response = FandomApi.fetch(
      action: 'parse',
      page: page,
      prop: 'text'
    )

    html = response['parse']['text']['*']
    doc = Nokogiri::HTML(html)

    events = []

    heading = doc.at_xpath("//*[contains(text(), 'List of Events')]")

    table = heading&.xpath('following::table[1]')&.first

    return [] unless table

    table.css('tr').each do |row|
      cells = row.css('td')
      next if cells.length < 2

      date = clean_date(cells[2].text.strip)

      link = cells[1].at_css("a[href^='/wiki/']")
      next unless link

      wiki_title =
        link['href']
        .sub('/wiki/', '')
        .then { |value| CGI.unescape(value) }
        .gsub('_', ' ')

      # title = wiki_title.sub(%r{^HoYoLAB/Articles/}, '')

      events << {
        title: wiki_title,
        date: date,
        series: page,
        type: 'Event',
        version: VersionHelper.check(date)
      }
    end

    events
  end

  def self.clean_date(raw)
    Date.parse(raw).to_s
  rescue ArgumentError
    nil
  end
end
