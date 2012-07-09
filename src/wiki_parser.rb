require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'

class WikiTravelCrawler
	
	attr_accessor :wiki_travel_base_url ,:pwd
	
	def initialize
		@wiki_travel_base_url = "http://wikitravel.org/en/"
		@pwd = `pwd`
	end
	
	def get_content(wiki_travel_page_title)
		puts "Fetching data from Web......."
		wiki_travel_full_url = URI.escape(@wiki_travel_base_url + wiki_travel_page_title.strip)
		wiki_travel_html_content = `wget #{wiki_travel_full_url} -O ../input/#{wiki_travel_page_title}`

		return wiki_travel_html_content	
	end

	def get_title
		puts "Enter wiki page title you want to parse : "
		wiki_title = gets
		wiki_content = get_content(wiki_title)
		wiki_doc = Nokogiri::HTML(wiki_content)
		output_file = File.open("../output/#{wiki_title}","w") 
		wiki_doc.xpath('//span[@class="editsection"]').each do | method_span |  
    			output_file.write  "#{method_span.css('a')[0]['title']}\n"  
		end  
	end

end

w = WikiTravelCrawler.new
w.get_title
