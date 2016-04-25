require 'yaml'
require './helper_methods.rb'

MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')
LANGUAGE = 'en'.freeze
MONTHS_IN_YEAR = 12

def validate_apr(apr)
  apr = apr.split('%')[0] # In case input has '%' sign, strip it
  number?(apr)
end

def validate_loan(loan)
  number?(loan)
end

def validate_duration(years)
  number?(years)
end

def loan_months(years)
  years * MONTHS_IN_YEAR
end

def monthly_interest_rate(apr)
  apr.to_f / (MONTHS_IN_YEAR * 100)
end

def loan_amount
  prompt('loan')
  loan = gets.chomp
  loan = validate_loan(loan) #####

  return loan if loan != false
  prompt('invalid_loan')
  loan_amount
end

def duration
  prompt('duration')
  years = gets.chomp
  years = validate_duration(years)

  return years if years != false
  prompt('invalid_duration')
  duration
end

def loan_apr
  prompt('apr')
  apr = gets.chomp
  apr = validate_apr(apr)

  return apr if apr != false
  prompt('invalid_apr')
  loan_apr
end

def monthly_payment
  loan = loan_amount
  months = loan_months(duration)
  rate = monthly_interest_rate(loan_apr)
  payment = loan * (rate * (1 + rate)**months) / ((1 + rate)**months - 1)
  payment.round(2)
end

def run_calculator
  prompt('welcome')
  payment = monthly_payment
  puts "Your monthly payments are: $#{payment} per month}"

  prompt('new')
  decision = gets.chomp

  if decision.casecmp('Y') == 0
    run_calculator
  else
    prompt('exit')
  end
end

run_calculator
