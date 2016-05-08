MESSAGES = YAML.load_file('tic_tac_toe_messages.yml')
LANGUAGE = 'en'.freeze

def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(key)
    puts "=> #{messages(key, LANGUAGE)}"
end

def integer?(num)
    Integer(num) rescue false
end

def float?(num)
    Float(num) rescue false
end

def number?(num)
    float?(num)
end

def deep_dup(collection)
  return collection.dup unless collection.is_a?(Array) || collection.is_a?(Hash)
  
  collection.is_a?(Array) ? array_deep_dup(collection) : hash_deep_dup(collection)
end

def array_deep_dup(array)
  array.map do |e|
    if e.is_a?(Array) || e.is_a?(Hash)
      deep_dup(e)
    else
      e.is_a?(Numeric) || e.is_a?(Symbol) ? e : e.dup
    end
  end.dup
end

def hash_deep_dup(hash)
  hash_copy = hash.dup
  
  hash.each do |key, value|
    if value.is_a?(Array) || value.is_a?(Hash)
      hash_copy[key] = deep_dup(value)
    else
      hash_copy[key] = value.dup unless value.is_a?(Numeric) || value.is_a?(Symbol)
    end
  end
  
  hash_copy
end

