# Module for reusable helper methods
module Helper
  def messages(message, lang = 'en')
    self.class::MESSAGES[lang][message]
  end

  def prompt(key, var = nil, var2 = nil)
    puts "=> #{messages(key, self.class::LANGUAGE)}" % { var: var, var2: var2 }
  end

  def display_welcome_message
    clear_screen
    prompt('welcome')
  end

  def display_goodbye_message
    prompt('exit')
  end

  def set_name
    prompt('name')
    nm = gets.chomp

    if nm.empty?
      prompt('invalid_name')
      set_name
    else
      self.name = nm
    end
  end

  def clear_screen
    system('clear') || system('cls')
  end
end
