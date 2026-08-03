# frozen_string_literal: true

require 'nokogiri'
require 'date'
require 'cgi'

require_relative 'fandom_api'
require_relative 'version_helper'

class Videos
  def self.parse(page)
    data = FandomApi.fetch(
      action: 'parse',
      page: page,
      prop: 'text'
    )

    html = data['parse']['text']['*']
    doc = Nokogiri::HTML(html)

    table = doc.at('table')
    return [] unless table

    videos = []

    table.css('tr').each do |row|
      cells = row.css('td').first(2)

      next if cells.length < 2

      file_link = cells[0].at_css("a[href^='/wiki/File:']")
      next unless file_link

      wiki_title =
        CGI.unescape(file_link['href'])
           .sub('/wiki/', '')

      title = cells[0].text.strip
      date = clean_date(cells[1].text.strip)

      videos << {
        title: title,
        wiki_title: wiki_title,
        date: date,
        series: page,
        type: 'Video',
        version: VersionHelper.check(date)
      }
    end

    videos
  end

  def self.clean_date(raw)
    Date.parse(raw.split('(').first.strip).to_s
  end
end
