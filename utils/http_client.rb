require 'net/http'
module HttpClient
  extend self
  def fetch(url)
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port) 
    http.use_ssl = (url.scheme == "https")
    http.request(req).body
  end
end
