def greet_user()
  Kernel.puts('Welcome to Calculator!')
end

def valid_operator?(operator)
  return false if operator.nil?
  return true if operator >= '1' && operator <= '4'
  false
end

def divide_by_zero?(operator, num1, num2)
  return false if num1 == 0
  return true if num2 == 0 && operator == '4'
  false
end

def get_numbers()
  Kernel.puts('please enter two numbers, separated by space:')
  numbers = Kernel.gets().chomp()
  numbers = numbers.split(' ')
  first_num = Integer(numbers[0])
  second_num = Integer(numbers[1])

  return [first_num, second_num]
  
rescue
  puts 'Invalid numbers.'
  retry
end

def get_operator()
  Kernel.puts('Enter operation to be performed:')
  Kernel.puts('Enter 1 for add, 2 for subtract, 3 for multiply or 4 divide')
  operator = Kernel.gets().chomp()
  return operator if valid_operator?(operator)
  puts Kernel.puts('Invalid operator.')
  get_operator()
end

def calculate(operator, num1, num2)
  case operator
  when '1'
    Kernel.puts("#{num1} + #{num2} = #{num1 + num2}")
  when '2'
    Kernel.puts("#{num1} - #{num2} = #{num1 - num2}")
  when '3'
    Kernel.puts("#{num1} x #{num2} = #{num1 * num2}")
  else
    Kernel.puts("#{num1} / #{num2} = #{num1 / num2}")
  end
end

def run_calculator()
  greet_user()
  num1, num2 = get_numbers()
  operator = get_operator()

  if !divide_by_zero?(operator, num1, num2) # check for division by zero error
    calculate(operator, num1, num2)
  else
    Kernel.puts('You can\'t divide a zero. Try again with valid inputs')
    run_calculator()
  end
end

run_calculator()

# Alternative ways of using "rescue" in #get_numbers()
=begin
def get_numbers()
    first_num = nil
    until first_num.is_a?(Fixnum) do #Could forgo loop and use "retry" instead
      Kernel.puts("please enter two numbers, separated by space:")
      begin
        numbers = Kernel.gets().chomp()
        numbers = numbers.split(' ')
        first_num = Integer(numbers[0])
        second_num = Integer(numbers[1])
      rescue ArgumentError # Raised when Integer is called with non integer argument
        first_num = nil        # Reset first_num so that the loop is re-entered
        puts "Invalid numbers. " # Inform user 
      end
    end
    
    return [first_num, second_num]
end
def get_numbers()
  Kernel.puts("please enter two numbers, separated by space:")
  numbers = Kernel.gets().chomp()
  numbers = numbers.split(' ')
  first_num = Integer(numbers[0])
  second_num = Integer(numbers[1])
rescue ArgumentError
  puts "Invalid numbers. "
  retry
else
  return [first_num, second_num]
end
=end
