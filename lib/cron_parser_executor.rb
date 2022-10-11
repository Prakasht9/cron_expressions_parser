require 'set'
require 'pry'
Dir["#{File.dirname(__FILE__)}/*"].each {|file| require file }


class CronParserExecutor

  def self.parse_cron(input)
    errors = {}

    parser_obj = CronParser.new(input, errors)
    unless errors.empty?
      display_errors(errors)
      return
    else
      parsed_data, parser_errors = parser_obj.parse(errors)
      unless parser_errors.keys.empty?
        display_errors(parser_errors)
        return
      else
        display_parsed_value(parsed_data)
        return parsed_data
      end
    end
    return
  end

  def self.display_errors(errors)
    puts errors
  end

  def self.display_parsed_value(parser_obj)
    INPUT_FORMAT.each do |inp_key|
      puts "#{inp_key.split('_').join(' ').ljust(13)}: #{parser_obj[inp_key].join(" ")}"
    end
  end
end