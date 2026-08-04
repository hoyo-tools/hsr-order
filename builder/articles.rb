# frozen_string_literal: true

require 'nokogiri'
require 'date'

require_relative 'fandom_api'
require_relative 'version_helper'

class Articles
  def self.parse(page)
    response = FandomApi.fetch(
      action: 'parse',
      page: page,
      prop: 'text'
    )

    html = response['parse']['text']['*']
    doc = Nokogiri::HTML(html)

    events = []

    doc.css('table:not(.navbox)').each do |table|
      table.css('tr').each do |row|
        cells = row.css('td')

        next if cells.length < 2

        date = clean_date(cells[0].text.strip)

        link = cells[1].at_css("a[href^='/wiki/']")
        next unless link

        wiki_title =
          link['href']
          .sub('/wiki/', '')
          .then { |value| CGI.unescape(value) }
          .gsub('_', ' ')

        title = wiki_title.sub(%r{^HoYoLAB/Articles/}, '')

        events << {
          title: title,
          wiki_title: wiki_title,
          date: date,
          series: page,
          type: 'Article',
          version: VersionHelper.check(date)
        }
      end
    end

    events
  end

  def self.clean_date(raw)
    Date.parse(raw).to_s
  rescue ArgumentError
    nil
  end
end
