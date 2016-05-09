MESSAGES = YAML.load_file('tic_tac_toe_messages.yml')
LANGUAGE = 'en'.freeze

def messages(message, lang = 'en')
  MESSAGES[lang][message]
end

def prompt(key)
  puts "=> #{messages(key, LANGUAGE)}"
end

def integer?(num)
  return Integer(num)
rescue
  return
end

def float?(num)
  return Float(num)
rescue
  return
end

def number?(num)
  float?(num)
end

def joinor(array, delimiter = ', ', conjunction = 'or')
  temp_array = array.map { |i| i + 1 }

  temp_array[-1] = "#{conjunction} #{temp_array[-1]}" if temp_array.length > 1
  temp_array.join(delimiter)
end

def clear_screen
  system('clear') || system('cls')
end
