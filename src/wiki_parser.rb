require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'

class WikiTravelCrawler
	
	attr_accessor :wiki_travel_base_url 
	
	def initialize
		@wiki_travel_base_url = "http://wikitravel.org/en/"
	end
	
	def get_content(wiki_travel_page_title)
		wiki_travel_full_url = URI.escape(@wiki_travel_base_url + wiki_travel_page_title)
		wiki_travel_html_content = Net::HTTP.get_response(URI.parse(wiki_travel_full_url))
		
		return wiki_travel_html_content	
	end

	def get_title
		puts "Enter wiki page title you want to parse : "
		wiki_title = gets
		wiki_content = get_content(wiki_title)
		puts wiki_content
	end

end

w = WikiTravelCrawler.new
w.get_title
