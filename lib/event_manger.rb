require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end
def numeric?(lookAhead)
  lookAhead.match?(/[[:digit:]]/)
end
def clean_phone_number(number)
  numbers_string = ""
  number_arr = number.to_s.split("")
  numbers = number_arr.filter {|char| numeric?(char)}
  numbers.each {|num| numbers_string.concat(num)}
  if numbers_string.length == 11 && numbers_string[0] == "1"
    format_number(numbers_string[1..10])
  elsif numbers_string.length > 10 || numbers_string.length < 10
    "bad number"
  else
    format_number(numbers_string)
  end
end
def format_number(number)
  counter = 1
  numbers_string = ""
  numbers = number.split("")
  numbers.each do |num|
    if counter % 3 == 0 && counter < 7
      numbers_string.concat("#{num}-")
    else
      numbers_string.concat(num)
    end
    counter += 1 
  end
  numbers_string
end
def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def format_date(date_and_time)
  date = Time.strptime(date_and_time,"%m/%d/%Y %k:%M")
  date = Time.new(date.year + 2000, date.month, date.day, date.hour,date.min)
end

def hour(date)
  date.hour
end

def week_day(date)
  date.wday
end

def average_hour(hours)
  hours.reduce {|sum,num| sum+= num}/hours.length
end
def average_week_day(days)
  days.reduce {|sum,num| sum+= num}/days.length
end
def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter
hours = Array.new
days = Array.new
contents.each do |row|
  id = row[0]

  

  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  phone_number = clean_phone_number(row[:homephone])

  date = format_date(row[:regdate])

  hours.push(hour(date))

  days.push(week_day(date))

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)

  puts "#{name} #{zipcode} #{phone_number} #{date}"
end

puts "Most Registerd hour: #{average_hour(hours)}"
puts "Most Registerd day: #{average_hour(days)}"

