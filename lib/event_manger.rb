puts 'Event Manager Initialized!'

sample_data = 'event_attendees.csv'
if File.exist? sample_data
  contents = File.read sample_data
  lines = File.readlines(sample_data)
    lines.each_with_index do |line,index|
      col = line.split(",")
      next if index == 0
      puts col[2]
    end
else
  puts "File not there"
end
