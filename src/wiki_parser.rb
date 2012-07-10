require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'

class WikiTravelCrawler
	
	attr_accessor :wiki_travel_base_url
	
	def initialize
		@wiki_travel_base_url = "http://wikitravel.org/en/"
	end
	
	def get_content(wiki_title)
	
		if is_available_locally(wiki_title)
			puts "Fetching data from local disk......."
			wiki_travel_html_content = File.read("../input/#{wiki_title}")
		else
			puts "Fetching data from Web......."
			wiki_travel_full_url = URI.escape(@wiki_travel_base_url + wiki_title)
			wiki_travel_html_content = `wget #{wiki_travel_full_url} -O ../input/#{wiki_title}`
		end

		return wiki_travel_html_content	
	end

	def is_available_locally(wiki_title)
		return File.exist?("../input/#{wiki_title}")
	end

	def get_title

		puts "Enter wiki page title you want to parse : "

		wiki_title = gets.strip
		wiki_content = get_content(wiki_title)
		wiki_doc = Nokogiri::HTML(wiki_content)
		output_file = File.open("../output/#{wiki_title}","w") 
    sections_completed = []
		wiki_doc.xpath('//span[@class="mw-headline"]').each do | method_span |
      wiki_section = method_span.inner_text
      next_element = method_span.parent.next_element
      latest_sub_section = wiki_section
      while (next_element != nil && (next_element.xpath('//h3') != nil || next_element.xpath('//h2') != nil || next_element.xpath('//h4') != nil))
        if next_element.inner_text.include?("[edit]")
          latest_sub_section = next_element.inner_text
        else
          if next_element.inner_text != nil
            if sections_completed.include?(latest_sub_section)
              output_file.write  "#{next_element.inner_text}\n"
            else
              output_file.write  "#{latest_sub_section} => #{next_element.inner_text}\n"
              sections_completed << latest_sub_section
            end
          end
        end
        next_element = next_element.next_element
      end
		end

	end

end

w = WikiTravelCrawler.new
w.get_title
