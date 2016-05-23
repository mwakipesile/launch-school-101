# Module for swimming pets
module Swimmable
  def swim
    'swimming!'
  end
end

# Pet class
class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

# Dog class
class Dog < Pet
  include Swimmable

  def speak
    'bark!'
  end

  def fetch
    'fetching!'
  end
end

# Bulldogs have own class since they can't swim
class Bulldog < Dog
  def swim
    'can\'t swim!'
  end
end

# Cat class
class Cat < Pet
  def speak
    'meow!'
  end
end

teddy = Dog.new
puts teddy.speak    # => "bark!"
puts teddy.swim     # => "swimming!"

ted = Bulldog.new
puts ted.speak
puts ted.swim

snow = Cat.new
p snow.speak
p snow.jump
p snow.run

# > Bulldog.ancestors
# => [Bulldog, Dog, Swimmable, Pet, Object, Kernel, BasicObject]
