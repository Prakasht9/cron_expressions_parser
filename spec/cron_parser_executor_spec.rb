# require 'cron_parser_executor'
require "cron_parser_executor"

describe CronParserExecutor do

  it 'should parse all the wildcard to original values' do
    input = "* * * * * /usr/bin/find"
    expected = {
      "command"=>["/usr/bin/find"],
      "min" => (0..59).to_a,
      "hour" => (0..23).to_a,
      "day_of_month"=> (1..31).to_a,
      "month"=> (1..12).to_a,
      "day_of_week" => (1..7).to_a
    }
    expect(CronParserExecutor.parse_cron(input)).to eq(expected)
  end

  it 'should parse the provided input' do
    input = "*/15 0 1,15 * 1-5 /usr/bin/find"

    expected = {
      "command"=>["/usr/bin/find"],
      "min" => [0, 15, 30, 45],
      "hour" => [0],
      "day_of_month"=> [1,15],
      "month"=> (1..12).to_a,
      "day_of_week" => [1,2,3,4,5].to_a
    }
    expect(CronParserExecutor.parse_cron(input)).to eq(expected)
  end
end