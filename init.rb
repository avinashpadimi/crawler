require 'pry'
require_relative './connection_pool'
require_relative './spider'
require_relative 'db/setup'
require_relative 'models/link'
require_relative 'utils/file_parser'

def is_valid_config?(config)
  config["pool_size"] || config["url"] || config["timeout"] || config["page_limit"]
end

begin 
  config = FileParser.parse('config.yml')
  puts "Configuration ..........."
  puts config

  unless is_valid_config?(config)
    puts "Invalid configuration please check README file to set the configuration"
    exit
  end

  pool = ConnectionPool.new(config["pool_size"])
  spider = Spider.new(config["url"],pool,config["page_limit"])
  spider.start 
  started_at = Time.now

  # Break the loop either crawling is done or Timeout
  loop do 
    sleep(5)
    if ((Time.now - started_at).to_i)/60 > config["timeout"]
      @timeout = true
    end
    break if spider.crawling_done? || @timeout || pool.no_active_thread?
  end

  pool.shutdown
  if @timeout
    puts "Url is not responding.........."
  else
    Link.create_links(spider.urls)
  end
end
