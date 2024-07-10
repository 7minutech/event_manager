require 'csv'
puts 'Event Manager Initialized!'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
  )
contents.each do |row|
  name = row[:first_name]
  zip_code = row[:zipcode]
  if zip_code.nil?
    zip_code = "00000"
  elsif zip_code.length < 5
    zip_code = zip_code.rjust(5,"0")
  elsif zip_code.length > 5
    zip_code = zip_code[0..4]
  end

  puts "#{name} #{zip_code}"
end
