def greet_user()
    Kernel.puts("Welcome to Calculator!")
end

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

def get_operator()
    Kernel.puts("Enter operation to be performed: Enter 1 for add, 2 for subtract, 3 for multiply or 4 divide")
    operator = Kernel.gets().chomp()
    operator
end

def calculate()
    greet_user()
    numbers = get_numbers()
    operator = get_operator()
    
    loop do 
        invalid_operator = false
        case operator
        when "1"
            Kernel.puts(numbers[0] + numbers[1])
        when "2"
            Kernel.puts(numbers[0] - numbers[1])
        when "3"
            Kernel.puts(numbers[0] * numbers[1])
        when "4"
            Kernel.puts(numbers[0] / numbers[1])
        else
            Kernel.puts("Invalid operator.")
            invalid_operator = true
            operator = get_operator
        end
        break if invalid_operator == false
    end
end

calculate()
