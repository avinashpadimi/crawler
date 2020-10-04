require "nokogiri"
require 'pry'

module UrlFinder
  extend self
  def urls(page_source,domain_name)
    urls = []
    link_data = Nokogiri::HTML.parse(page_source)
    link_data.xpath("//a").each do |url|
      urls << url[:href] if is_valid?(url) && is_valid_domain?(url[:href], domain_name)
    end
    urls
  end

  def is_valid?(url)
    !url.nil? && !url[:href].nil? && (url[:href].start_with?("http://") || url[:href].start_with?("https://"))
  end

  def find_domain_name url
    url = URI.parse(url)
    url.hostname
  end

  def is_valid_domain? url,domain_name
    find_domain_name(url) ==  domain_name
  end
end
