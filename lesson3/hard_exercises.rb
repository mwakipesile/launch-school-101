




# Solution 4. Return UUID
ALPHANUMERIC_CHARS = (0..9).to_a.concat(('a'..'f').to_a)

def rand_chrs(count)
  ALPHANUMERIC_CHARS.sample(count).join
end

def uuid
  [8, 4, 4, 4, 12].map { |n| rand_chrs(n) }.join('-')
end

# Solution 5. Fix Ben's mess
def dot_separated_ip_address?(input_string)
  dot_separated_words = input_string.split(".")
  
  return false if dot_separated_words.length != 4
  
  dot_separated_words.each { |w| return false unless is_a_number?(w) }
  
  true
end
