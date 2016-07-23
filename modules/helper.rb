# Module for reusable helper methods
module Helper
  def messages(message, lang = 'en')
    self.class::MESSAGES[lang][message]
  end

  def prompt(key, var = nil, var2 = nil, var3 = nil, var4 = nil)
    puts "=> #{format(
      messages(key, self.class::LANGUAGE),
      var: var,
      var2: var2,
      var3: var3,
      var4: var4
    )}"
  end

  def display_welcome_message(name = '')
    clear_screen
    prompt('welcome', name)
  end

  def display_goodbye_message
    prompt('exit')
  end

  def set_name
    prompt('name')
    nm = gets.chomp

    if alpha?(nm)
      self.name = nm
    else
      prompt('invalid_name')
      set_name
    end
  end

  def alpha?(word)
    return false unless word.is_a?(String)

    letters = ('a'..'z').to_a

    word.each_char do |char|
      return true if letters.include?(char.downcase)
    end

    false
  end

  def clear_screen
    system('clear') || system('cls')
  end
end
