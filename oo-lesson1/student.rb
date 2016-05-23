# Student class
class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    grade > other_student.grade
  end

  protected

  attr_reader :grade
end

joe = Student.new('Joe', 82)
bob = Student.new('Bob', 75)
puts 'Well done!' if joe.better_grade_than?(bob)
# => Well done!
bob.grade
# => student.rb:20:in `<main>': protected method `grade' called for
# => #<Student:0x00000002180ea0 @name="Bob", @grade=75> (NoMethodError)
