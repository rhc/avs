#!/usr/bin/env ruby

require 'csv'
require 'caxlsx'
require 'optparse'
require 'ruby-progressbar'

MAX_TABSHEET_NAME_LENGTH = 31 # in Excel
MAX_FORMATABLE_ROWS = 500_000

def generate_column_names(n)
  names = []
  while n >= 0
    names.unshift((n % 26 + 65).chr)
    n /= 26
    n -= 1
  end
  names.join('')
end

def generate_sheet(wb, filename, sheet_name)
  table = CSV.parse(File.open(filename),
                    headers: true,
                    quote_char: '"',
                    force_quotes: false,)
  count = table.length + 1
  # progress_bar = ProgressBar.new(sheet_name, max)
  # progress_bar = Tqdm::ProgressBar.new("#{sheet_name} [:bar] :percent", total: count)
  progress_bar = ProgressBar.create(total: count, format: '%a %B %p%% %E')
  headers = table.headers
  basename = File.basename(filename, '.*')
  column_names = headers.map.with_index { |_, i| generate_column_names(i) }
  # puts "headers #{headers}"
  # p column_names

  bottom_right_cell = "#{column_names.last}#{count}".upcase
  # puts "bottom_right_cell #{bottom_right_cell}"
  range = "A1:#{bottom_right_cell}"
  # puts "range: #{range}"

  wb.add_worksheet(name: sheet_name) do |sheet|
    sheet.add_row headers
    counter = 1
    table.each do |row|
      counter += 1
      if counter % 100 == 0
        progress_bar.progress += 100
      end
      types = row.fields.map do |f|
        if f =~ /^\d+$/
          :integer
        elsif f =~ /^\d{4}\-\d{2}\-\d{2}/
          :date
        elsif f =~ /^\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}(.\d*)*/
          :datetime
        else
          :string
        end
      end

      widths = row.fields.map { |f| f.to_s.length > 40 ? 40 : nil }
      parsed_row = CSV.parse_line(row.to_csv.chomp)
      # Convert date strings to Date objects
      parsed_row = parsed_row.map do |value|
        if value =~ /^\d+$/
          value.to_i
        elsif value =~ /\A\d{4}\-\d{2}\-\d{2}\z/
          date = DateTime.strptime(value, "%Y-%m-%d")
        elsif value =~ /\A\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}(?:\.\d{0,3})?\z/
          date = DateTime.strptime(value, "%Y-%m-%d") # TODO
        else
          value
        end
      end
      sheet.add_row parsed_row, types: types, widths: widths
    end
    progress_bar.progress = count
    if count < MAX_FORMATABLE_ROWS
      sheet.add_table range, name: basename, style_info: { name: 'TableStyleMedium23' }
    end
  end
end

# Parse command line options
options = {}
opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby csv_to_xlsx.rb [options] input_file1 [input_file2 ...]"
  opts.on('-n', '--name FILENAME', 'Output filename') do |filename|
    options[:output_filename] = filename
  end
  opts.on('-s', '--suffix SUFFIX', 'Output file suffix') do |suffix|
    options[:suffix] = suffix
  end
end

opt_parser.parse!

# Check if the output filename was provided
if options[:output_filename].nil?
  # If no output filename was provided,
  # use the name of the first input file with the extension xlsx
  options[:output_filename] = File.basename(ARGV.first, '.*')
  options[:output_filename] += "_" + options[:suffix] unless options[:suffix].nil?
  options[:output_filename] += '.xlsx'
  options[:output_filename] = File.dirname(ARGV.first) + '/' + options[:output_filename]
else
  dirname = File.dirname(options[:output_filename])
  options[:output_filename] = File.basename(options[:output_filename], '.*')
  options[:output_filename] += "_" + options[:suffix] unless options[:suffix].nil?
  options[:output_filename] += '.xlsx'
  options[:output_filename] = dirname + '/' + options[:output_filename]
end

# Generate worksheets from each CSV file
package = Axlsx::Package.new
wb = package.workbook

ARGV.each do |filename|
  if !File.exists?(filename)
    puts "Error: #{filename} does not exist."
    puts opt_parser
  end

  sheet_name = File.basename(filename, '.*').capitalize.gsub('_', ' ')
  generate_sheet(wb, filename, sheet_name[0, MAX_TABSHEET_NAME_LENGTH])
end

# Serialize the workbook to an xlsx file
begin
  package.serialize(options[:output_filename], confirm_valid: true)
  puts "File saved to #{options[:output_filename]}"
rescue Exception => e
  puts "Serialization error with #{e}"
  exit
end
