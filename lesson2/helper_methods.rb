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

