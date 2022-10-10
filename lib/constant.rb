MIN = 'min'
HOUR = 'hour'
DAY_OF_MONTH = 'day_of_month' 
MONTH = 'month'
DAY_OF_WEEK = 'day_of_week'
COMMAND = 'command'

WILDCARD = 'wildcard'
FIXED = 'fixed'
RANGE = 'range'
FREQUENCY = 'frequency'
LIST = 'list'

INPUT_FORMAT = [MIN, HOUR, DAY_OF_MONTH, MONTH, DAY_OF_WEEK, COMMAND]
DATA_RANGE = {
  MIN => "0-59",
  HOUR => "0-23",
  DAY_OF_MONTH => "1-31",
  MONTH => "1-12",
  DAY_OF_WEEK => "1-7"
}
