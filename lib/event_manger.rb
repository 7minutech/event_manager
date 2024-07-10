puts 'Event Manager Initialized!'

sample_data = 'event_attendees.csv'
if File.exist? sample_data
  contents = File.read sample_data
  lines = File.readlines(sample_data)
    lines.each do |line|
      cols = line.split(",")
      name = cols[2]
      puts name
    end
else
  puts "File not there"
end
