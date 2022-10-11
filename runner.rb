Dir["#{File.dirname(__FILE__)}/lib/*"].each {|file| require file }

input = ARGV
if input.length != 1 or input.class.name != 'Array'
  puts ({'invalid input': 'Input should be a Single String' })
  return
end

CronParserExecutor.parse_cron(*ARGV)