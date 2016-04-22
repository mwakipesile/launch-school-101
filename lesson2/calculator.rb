def greet_user()
    Kernel.puts("Welcome to Calculator!")
end

=begin
def get_numbers()
    first_num = nil

    until first_num.is_a?(Fixnum) do
      Kernel.puts("please enter two numbers, separated by space:")
      begin
        numbers = Kernel.gets().chomp()
        numbers = numbers.split(' ')
        first_num = Integer(numbers[0])
        second_num = Integer(numbers[1])
      rescue ArgumentError # Raised when Integer is called with non integer argument
        first_num = nil        # Reset first_num so that the loop is re-entered
        puts "Invalid numbers. " #Inform user 
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

def get_numbers()
  Kernel.puts("please enter two numbers, separated by space:")
  numbers = Kernel.gets().chomp()
  numbers = numbers.split(' ')
  first_num = Integer(numbers[0])
  second_num = Integer(numbers[1])

  return [first_num, second_num]
  
  rescue
    puts "Invalid numbers."
  retry
end

def get_operator()
    Kernel.puts("Enter operation to be performed: Enter 1 for add, 2 for subtract, 3 for multiply or 4 divide")
    operator = Kernel.gets().chomp()
    operator
end

def calculate(operator, num1, num2)
    case operator
    when "1"
        Kernel.puts(num1 + num2)
    when "2"
        Kernel.puts(num1 - num2)
    when "3"
        Kernel.puts(num1 * num2)
    when "4"
        Kernel.puts(num1 / num2)
    else
        Kernel.puts("Invalid operator.")
        operator = get_operator()
        calculate(operator, num1, num2)
    end
end

def run_calculator()
    greet_user()
    num1, num2 = get_numbers()
    operator = get_operator()
    if operator == "4" && num2 == 0
        Kernel.puts("You can't divide a zero. Try again with valid inputs")
        run_calculator()
    else
        calculate(operator, num1, num2)
    end
end

run_calculator()
