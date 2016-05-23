# Passengers module
module Passengers
  attr_reader :passengers
end

# Class Vehicle
class Vehicle
  attr_accessor :color
  attr_reader :year, :model, :current_speed
  @vehicle_count = 0

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @current_speed = 0
    self.class.vehicle_count += 1
  end

  def speed_up(velocity_change)
    @current_speed += velocity_change
  end

  def brake(velocity_change)
    @current_speed -= velocity_change
  end

  def shut_down
    @current_speed = 0
  end

  def spray_paint(color)
    self.color = color
  end

  def self.gas_mileage(miles, gallons)
    miles / gallons
  end

  def self.number_of_vehicles
    puts "Number of vehicles created so far is #{@vehicle_count}"
  end

  def to_s
    "#{color.capitalize} #{year} #{model}"
  end

  def age
    "This #{model} is #{calculate_vehicle_age} years old."
  end

  def self.vehicle_count
    @vehicle_count
  end

  def self.vehicle_count=(value)
    @vehicle_count = value
  end

  private

  def calculate_vehicle_age
    Time.now.year - year
  end
end

# Car class
class MyCar < Vehicle
  include Passengers

  @vehicle_count = 0

  def initialize(year, model, color, passengers)
    super(year, model, color)
    @passengers = passengers
  end
end

# Truck class
class MyTruck < Vehicle
end

my_car = MyCar.new(2009, 'Hyundai Sonata', 'silver', 5)
MyCar.number_of_vehicles
# => Number of vehicles created so far is 1
MyTruck.number_of_vehicles
# => Number of vehicles created so far is 1
my_car.speed_up(80)
# => 80
my_car.brake(15)
# => 65
my_car.brake(15)
# => 50
MyCar.gas_mileage(341, 11)
# => 31
my_car.spray_paint('black')
# => "black"
puts my_car
# Black 2009 Hyundai Sonata

# 4. Print to the screen your method lookup for the classes that you created
puts MyCar.ancestors
# MyCar
# Passengers
# Vehicle
# Object
# Kernel
# BasicObject
puts MyCar.ancestors
# MyTruck
# Vehicle
# Object
# Kernel
# BasicObject
puts Vehicle.ancestors
# Vehicle
# Object
# Kernel
# BasicObject
