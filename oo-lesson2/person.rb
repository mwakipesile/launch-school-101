# Person class
class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(name)
    parse_full_name(name)
  end

  def same_name?(other_person)
    name == other_person.name
  end

  def to_s
    name
  end

  private

  def parse_full_name(name)
    names = name.split

    self.first_name = names[0]
    self.last_name = names[1] ? names[1] : ''
  end
end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

chris = Person.new('Chris Lee')
p chris.name                # => "Chris Lee"
p chris.first_name          # => "Chris"
p chris.last_name           # => "Lee"

bob.name = 'John Adams'
p bob.name                  # => 'John Adams'
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')
p bob.same_name?(rob)       # => true

# 4.
# The above code compares a string with a string. But aren't strings
# also just objects of String class? If we can't compare two Person
# objects with each other with ==, why can we compare two different
# String objects with ==?

# REASON: Comparison between strings, arrays, hashes compare objects themselves
# bob == rob compares object ids; which would be different for different objects

# 5.
bob = Person.new('Robert Smith')
puts "The person's name is: #{bob}"
# => 'The person's name is: #<Person:0x000000018a97a0>' before #to_s override
# => 'The person's name is: Robert Smith' after custom to_s
