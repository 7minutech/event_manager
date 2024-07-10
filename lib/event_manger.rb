require 'csv'
require 'google/apis/civicinfo_v2'



def clean_zip_code(zip_code)
  zip_code.to_s.rjust(5,'0')[0..4]
end

def legislators_by_zip_code(zip_code)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  begin
    legislators = civic_info.representative_info_by_address(  
      address: zip_code,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody'] 
    )
    legislators = legislators.officials
    legislators_names = legislators.map(&:name)
    legislators_string = legislators_names.join(", ")

  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
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
  legislators = legislators_by_zip_code(zip_code)
  
  puts "#{name} #{zip_code} #{legislators}"
end
