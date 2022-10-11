class CronParser
  
  attr_accessor :min, :hour, :day_of_month, :month, :day_of_week, :command
  def initialize(input, errors)
    if input.class.name != 'String'
      errors['argument_error'] = 'inappropriate data format'
      return
    end

    values = input.split(" ")
    if values.length != 6
      errors['argument_error'] = 'Wrong number of argument'
      return
    end

    self.min = values[0]
    self.hour = values[1]
    self.day_of_month = values[2]
    self.month = values[3]
    self.day_of_week = values[4]
    self.command = values[5]
  end
  
  def parse(errors)
    errors, data_types = Validate.validate_datatype(self, errors)

    return errors unless errors['data_type'].empty?

    replace_wildcard_values(data_types)
    result, parser_errors = parse_values(data_types)
    return result, parser_errors
  end

  def replace_wildcard_values(data_types)
    wildcard_keys = []
    data_types.each do |key, value|
      if value == WILDCARD
        self.send("#{key}=", DATA_RANGE[key])
        wildcard_keys << key
      end
    end
    wildcard_keys.each do |wkey|
      data_types[wkey] = RANGE
    end
  end

  def parse_values(data_types)
    result = {}
    parser_errors = {}
    result['command'] = [self.command.to_s]
    INPUT_FORMAT.each do |inp_key|
      next if inp_key == COMMAND
      data_type = data_types[inp_key]
      self.send("parse_#{data_type}", inp_key, result, parser_errors)
    end
    return result, parser_errors
  end

  def parse_fixed(inp_key, result, parser_errors)
    result[inp_key] = [self.send(inp_key.to_sym).to_i]
    return result, parser_errors
  end

  def parse_range(inp_key, result, parser_errors)
    default_left, default_right = DATA_RANGE[inp_key].split("-").map(&:to_i)
    left, right = self.send(inp_key.to_sym).split("-").map(&:to_i)
    if left < default_left || right > default_right || left > right
      parser_errors[inp_key] = 'Left and right values missmatch'
      return result, parser_errors
    end
    range_values = (left..right).to_a
    result[inp_key] = range_values

    return result, parser_errors
  end

  def parse_frequency(inp_key, result, parser_errors)
    default_left, default_right = DATA_RANGE[inp_key].split("-").map(&:to_i)
    default_values = (default_left..default_right).to_a

    freq = self.send(inp_key.to_sym).split("/")

    if freq.length < 2
      parser_errors[inp_key] = 'frequency should have atleast 2 values'
      return result, parser_errors
    end

    numerator, denominator = freq
    if denominator.to_i.to_s != denominator || denominator.to_i == 0
      parser_errors[inp_key] = 'frequency divisor is incorrect'
      return result, parser_errors
    end

    freq_set = {}
    if Validate.is_wildcard?(numerator)
      freq_set = default_values
    elsif Validate.is_fixed?(numerator)
      if numerator.to_i % denominator.to_i == 0
        freq_set = default_values
      else
        freq_set = (numerator.to_i..default_right).to_a
      end
    elsif Validate.is_range?(numerator)
      r_start, r_end = self.send(inp_key.to_sym).split("-").map(&:to_i)

      if r_start < default_left || r_end > default_right || r_start > r_end
        parser_errors[inp_key] = 'Left and right values missmatch'
        return result, parser_errors
      end
      range_values = (r_start..r_end).to_a
      freq_set = (r_start..r_end).to_a
    else
      parser_errors[inp_key] = 'numerator value for frequency is incorrect'
      return result, parser_errors
    end

    frequency_values = [freq_set[0]]
    denominator = denominator.to_i
    frequency_start = freq_set[0] + denominator 

    while(frequency_start < freq_set[-1])
      frequency_values << frequency_start
      frequency_start += denominator
    end
    result[inp_key] = frequency_values
  end

  def parse_list(inp_key, result, parser_errors)
    default_left, default_right = DATA_RANGE[inp_key].split("-").map(&:to_i)
    default_values = (default_left..default_right).to_a.to_set

    list = self.send(inp_key.to_sym).split(",")

    if list.length < 2
      parser_errors[inp_key] = 'list should have atleast 2 values'
      return result, parser_errors
    end

    list_values = []
    list_errors = []
    list.each do |val|
      curr_val = val.to_i
      if curr_val.to_s != val
        list_errors << 'list include non numric value'
      elsif !default_values.include?(curr_val)
        list_errors << 'list contains out of range values'
      elsif default_values.include?(curr_val)
        list_values << val.to_i
      end
    end

    unless list_errors.empty?
      parser_errors[inp_key] = list_errors
      return result, parser_errors
    end
    result[inp_key] = list_values
    return result, parser_errors
  end
end
