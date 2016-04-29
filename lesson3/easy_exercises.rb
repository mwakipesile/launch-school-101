# Turn this array into a hash where the names are the keys and the
# values are the positions in the array.
flintstones = %w(Fred Barney Wilma Betty Pebbles BamBam)

# Solution i
Hash[(0...flintstones.size).zip(flintstones)].invert

# Solution ii
flintstones.map.with_index { |name, i| [name, i] }.to_h

# or
flintstones.map.with_index { |*name| name }.to_h

# Solution iii
Hash[flintstones.map.with_index { |name, i| [name, i] }]

# Solution iv
flintstones.map.with_index.with_object({}) { |a, hash| hash[a[0]] = a[1] }

flintstones.map.with_index { |*x| x }.to_h

# Add up all of the ages from our current Munster family hash:
ages = {
  'Herman' => 32,
  'Lily' => 30,
  'Grandpa' => 5843,
  'Eddie' => 10,
  'Marilyn' => 22,
  'Spot' => 237
}
ages.values.inject(:+)

# Throw out the really old people (age 100 or older).
ages = { 'Herman' => 32, 'Lily' => 30, 'Grandpa' => 402, 'Eddie' => 10 }
ages.delete_if { |_, age| age >= 100 }

# Case of The Munsters
munsters_description = 'The Munsters are creepy in a good way.'

munsters_description.capitalize!
munsters_description.swapcase!
munsters_description.downcase!
munsters_description.upcase!

# Welcome Marilyn and Spot to the family
ages = { 'Herman' => 32, 'Lily' => 30, 'Grandpa' => 5843, 'Eddie' => 10 }
additional_ages = { 'Marilyn' => 22, 'Spot' => 237 }

ages.merge!(additional_ages)

# Pick out the minimum age from our current Munster family hash:
ages = {
  'Herman' => 32,
  'Lily' => 30,
  'Grandpa' => 5843,
  'Eddie' => 10,
  'Marilyn' => 22,
  'Spot' => 237
}

ages.values.min

# Finding dino
advice = 'Few things in life are as important as house training' \
          'your pet dinosaur.'

advice.match('dino')

# Find the index of the first name that starts with "Be"
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

flintstones.index { |name| name.start_with?('Be') }

# Using array#map!, shorten each of these names to just 3 characters:
flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

flintstones.map! { |name| name[0..2] }

# Remove everything starting from "house".
advice = 'Few things in life are as important as house training' \
          'your pet dinosaur.'

advice.slice!(0...advice.index('house'))
