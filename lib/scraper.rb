require 'mechanize'

require_relative 'stories'
  
URLS = { 
    reddit: {},
    lobsters: { frontpage: 'http://lobste.rs/',
                recent: 'http://lobste.rs/recent/',
                search: 'http://lobste.rs/search/' }
}

module Scraper
  class Lobsters
    attr_accessor :browser
    def initialize
      @urls = URLS[:lobsters]
      @browser = Mechanize.new
    end

    def frontpage(page)
      parse_page(@browser.get("#{URLS[:lobsters][:frontpage]}page/#{page}"))
    end

    def recent(page)
      parse_page(@browser.get("#{URLS[:lobsters][:recent]}page/#{page}"))
    end
    
    def parse_page(page)
      { results: page.search('.details')
                 .map { |link| Stories::LobstersStory.new(link) }
      }.to_json
    rescue
      { error: 'Page parsing error' }.to_json
    end
  end
end
