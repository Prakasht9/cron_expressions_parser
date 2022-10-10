class Validate

  def self.validate_datatype(input, errors)
    error_map = {}
    type_map = {}
    INPUT_FORMAT.each do |key|
      next if key == COMMAND
      value = input.send(key.to_sym)
      
      if is_wildcard?(value)
        type_map[key] = WILDCARD
      elsif is_fixed?(value)
        type_map[key] = FIXED
      elsif is_frequency?(value)
        type_map[key] = FREQUENCY
      elsif is_range?(value)
        type_map[key] = RANGE
      elsif is_list?(value)
        type_map[key] = LIST
      else
        error_map[key] = 'inappropriate type'
      end
    end

    errors['data_type'] = error_map
    return errors, type_map
  end

  def self.is_wildcard?(value)
    return value == "*"
  end

  def self.is_fixed?(value)
    return value.to_i.to_s == value
  end

  def self.is_range?(value)
    range_values = value.split("-")
    return false if range_values.length != 2
    return true
  end

  def self.is_frequency?(value)
    frequency_values = value.split("/")
    return false if frequency_values.length < 2
    # return false if value.to_i.to_s != value
    return true
  end

  def self.is_list?(value)
    list_values = value.split(",")
    return false if list_values.length < 2
    return true
  end
end