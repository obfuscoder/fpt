# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc 'Imports waypoints from doc.kml file'
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

desc 'Updates all outdated plate images'
task :update_plates do
  %w[caucasus nttr pg syria].each do |folder|
    root_path = Rails.root.join('public', folder)
    Dir.glob(root_path + '**/*.pdf').each do |pdf_path|
      puts "Updating plate for #{pdf_path} ..."
      pdf_path = Pathname.new pdf_path
      png_path = pdf_path.sub_ext '.png'
      next if png_path.exist? && png_path.mtime >= pdf_path.mtime

      images = Magick::ImageList.new(pdf_path) do
        self.density = '200'
        self.colorspace = Magick::RGBColorspace
      end
      image = images.first
      image.resize! 540 * 2, 814 * 2
      image.alpha Magick::RemoveAlphaChannel
      image.format = 'png'
      image.write png_path
    end
  end
end
