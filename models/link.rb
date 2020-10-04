class Link < ActiveRecord::Base
  def self.create_links urls
    group_by_url = urls.group_by {|_a| _a.split("?")[0] }
    final_data = group_by_url.map do |url, urls|
      {
        link: url,
        reference_count: urls.count,
        query_params: collect_params(urls)
      }
    end
    self.create(final_data)
  end

  def self.collect_params urls
    urls.map do |_url|
      u = URI.parse(_url) rescue next
      u.query.nil? ? nil : Hash[*u.query.split("&").map{|a| a.split("=") }.flatten].keys 
    end.flatten.uniq.compact.join(",")
  end
end
