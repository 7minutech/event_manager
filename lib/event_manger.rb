require 'csv'

def clean_zip_code(zip_code)
  if zip_code.nil?
    "00000"
  elsif zip_code.length < 5
    zip_code.rjust(5,"0")
  elsif zip_code.length > 5
    zip_code[0..4]
  else
    zip_code
  end
end

puts 'Event Manager Initialized!'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
  )
contents.each do |row|
  name = row[:first_name]
  zip_code = clean_zip_code(row[:zipcode])
  puts "#{name} #{zip_code}"
end
