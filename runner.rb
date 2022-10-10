Dir["#{File.dirname(__FILE__)}/lib/*"].each {|file| require file }
CronParserExecutor.parse_cron(*ARGV)