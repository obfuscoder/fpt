# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task :import do
  xml = Nokogiri::XML(File.open('doc.kml'))
  File.open('wps.yaml', 'w') do |f|
    xml.xpath('//Placemark/Point/coordinates/../..').each do |node|
      name = node.xpath('name').text
      lat, lon, alt = node.xpath('Point/coordinates').text.split(',')
      f.puts "    - name: #{name}"
      f.puts "      lat: #{lat}"
      f.puts "      lon: #{lon}"
    end
  end
end
