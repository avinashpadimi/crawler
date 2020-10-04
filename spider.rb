
require_relative './utils/http_client'
require_relative './utils/url_finder'
require 'pry'

class Spider
  # url : Source 
  # depth : total number of urls we have to crawl 
  attr_accessor :connection_pool,:urls
  def initialize url, connection_pool, no_of_pages = 10
    @page_limit = no_of_pages
    @source_url = url
    @url_count = 0
    @connection_pool = connection_pool
    @shutdown = false
    @urls = @pages = []
    @pages_visited = 0
    @domain_name = UrlFinder.find_domain_name(url)
    @crawler  = Proc.new do |url| 
      print "\nFetching : #{url} ..............."
      page_source_code = HttpClient.fetch(url)
      print "#{url}----------done\n"
      urls = UrlFinder.urls(page_source_code,@domain_name)
      @pages_visited += 1
      @urls += urls
      visited_all_pages? ? @shutdown =  true : push_to_queue(urls)
    end
  end

  def start
    push_to_queue([@source_url])
  end

  def push_to_queue(urls)
    urls.each do |url| 
      break if is_limit_over?
      unless @pages.include?(url)
        @pages << url
        connection_pool.schedule(url, @crawler)
      end
    end
  end

  def crawling_done?
    @shutdown == true
  end

  def urls_count
    @urls.count
  end

  private

  def is_limit_over?
    @pages.count > @page_limit
  end

  def visited_all_pages?
    is_limit_over? && @pages_visited >= (@pages.count - 1)
  end
end
