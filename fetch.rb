require 'mechanize'

@mechanize = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
end

def fetch_images_from page
  page.image_urls.each do |img|
    @mechanize.get(img).save_as "images/#{File.basename(img.path)}" rescue Net::HTTPNotFound
  end
end

urls = ['http://conceptrobots.blogspot.com/']

while not urls.empty?
  @mechanize.get(urls.pop) do |page|
    link = page.links.find { |l| l.attributes[:title] =~ /Older/ }
    urls << link.href if link
    puts "Fetching #{page.uri.to_s}..."
    fetch_images_from page
  end
end
