require_relative 'student'

def main_loop
  loop do
    puts "(1) Student Management
(2) Teacher Management
(3) Course Management
(4) Subject Management
(5) Exit
"

    print "Enter the number:"
    option = gets.chomp

    case option
    when '1'
      Student.options
    when '2'
      Teacher.options
    when '3'
      Course.options
    when '4'
      Subject.options
    when '5'
      puts "\nSystem exit."
      exit
    end
  end
end

# Start of Code
main_loop()