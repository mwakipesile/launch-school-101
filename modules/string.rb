# Module for reusable String methods
module StringHelper
  def joinor(array, delimiter = ', ', conjunction = 'or')
    temp_array = array.dup

    temp_array << "#{conjunction} #{temp_array.pop}" if temp_array.size > 1
    temp_array.join(delimiter)
  end
end
