# 1. ask user to submit loan amount, APR, and loan duration
    # i) validate user inputs
# 2. calculate monthly interest rate
# 3. calculate load duration in months
require 'yaml'
require './helper_methods.rb'

MESSAGES = YAML.load_file('mortgage_calculator_messages.yml')
LANGUAGE = 'en'
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

def get_loan
  prompt('loan')
  loan = gets.chomp
  loan = validate_loan(loan) #####
  
  return loan if loan != false
  prompt('invalid_loan')
  get_loan
end

def get_duration
  prompt('duration')
  years = gets.chomp
  years = validate_duration(years)
  
  return years if years != false
  prompt('invalid_duration')
  get_duration
end

def get_apr
  prompt('apr')
  apr= gets.chomp
  apr = validate_apr(apr)
  
  return apr if apr != false
  prompt('invalid_apr')
  get_apr
end

def run_calculator
    prompt('welcome')
    loan = get_loan
    months = loan_months(get_duration)
    rate = monthly_interest_rate(get_apr)
    monthly_payment = loan * (rate * (1 + rate)**months ) / ((1 + rate)**months - 1)
    puts "Your monthly payments are: $#{monthly_payment.round(2)} per month}"
end

run_calculator

    
    
    
    
#fixed_monthly_payment = loan(monthly_interest_rate(1 + monthly_interest_rate)**months) / ((1 + monthly_interest_rate)**months - 1)








      
      