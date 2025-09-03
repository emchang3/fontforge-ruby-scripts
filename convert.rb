require 'fontforge_ruby'

source_folder = 'more-fonts'
base_path = `pwd`

puts "--- args: #{ARGV}"

files = Dir.entries("#{base_path}/input")
  # .select { |f| !f.match(/Quiche/).nil? }

if ARGV.include?('--use-groups')
  groups = {}
  files.each do |f|
    group = f.split(' ')[0]
    puts group
  
    if group.match(/[a-zA-Z]+/).nil?
      next
    end
  
    name = f.split('.')[0]
    path = "#{base_path}/output/#{name}"
  
    if groups["#{group}"].nil?
      groups["#{group}"] = [name]
    else
      groups["#{group}"] << name
    end
  end
  
  threads = []
  
  groups.each do |group, fonts|
    puts "#{base_path}/output/#{group}"
    Dir.mkdir("#{base_path}/output/#{group}")
  
    fonts.each do |font|
      threads << Thread.new {
        FontforgeRuby.convert(
          "#{base_path}/input/#{font}.ttf",
          "#{base_path}/output/#{group}/#{font}.otf"
        )
      }
    end
  end
  
  threads.each(&:join)
else
  threads = []

  files.each do |f|
    threads << Thread.new {
      font = f.split('.')[0]

      FontforgeRuby.convert(
        "#{base_path}/input/#{font}.ttf",
        "#{base_path}/output/#{font}.otf"
      )
    }
  end
  
  threads.each(&:join)
end

