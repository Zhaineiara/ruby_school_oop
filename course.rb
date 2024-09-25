class Course
  attr_accessor :id, :name
  @@record = []
  @@next_id = 1

  def initialize(name, delete_at = nil)
    @id = @@next_id
    @@next_id += 1
    @name = name
    @delete_at = delete_at
  end

  def save
    course_existence = @@record.find { |program| program[:id] == @id }

    if course_existence
      course_existence[:name] = @name
    else
      @@record.append({ id: @id, name: @name, delete_at: @delete_at })
    end
  end

  def self.destroy(id)
    find_record = @@record.find { |program| program[:id] == id }
    if find_record
      find_record[:delete_at] = Time.now
    else
      puts "Course with ID #{id} not found."
    end
  end

  def display
    puts "Id: #{@id}\nName: #{@name}"
  end

  def self.all
    clear_screen
    puts "VIEW RECORD"
    if @@record.empty?
      puts "\nNo courses to display."
    else
      @@record.each_with_index do |program, index_number|
        if program[:delete_at]
          puts "\nCourse Record #{index_number + 1} is marked as deleted (Deleted at: #{program[:delete_at]})"
        else
          puts "\nCourse Record #{index_number + 1}\nCourse_id: #{program[:id]}\nName: #{program[:name]}"
        end
      end
    end
    print("\n")
    exit_management
  end

  def self.all_records
    @@record.reject { |course| course[:delete_at] }
  end

  def self.find
    clear_screen
    puts "SEARCH COURSE"
    print "Enter ID: "
    @id = gets.chomp.to_i

    course_existence = @@record.find { |program| program[:id] == @id }

    if course_existence.nil?
      puts "\nCourse not found."
      exit_management
      return
    end

    if course_existence[:delete_at]
      puts "\nCourse Record is marked as deleted (Deleted at: #{course_existence[:delete_at]})"
    else
      clear_screen
      puts "DATA IN THE GIVEN ID"
      puts "Name: #{course_existence[:name]}"
    end

    print("\n")
    exit_management
  end

  def self.add
    clear_screen
    puts "ADD COURSE"

    print "Enter name:"
    @name = gets.chomp
    course = Course.new(@name)
    course.save

    clear_screen
    puts "COURSE DETAILS\n"
    course.display
    puts "\nCourse added successfully!"
    exit_management
  end

  def self.exit_management
    print "Enter 0 to go back to course management."
    choice = gets.chomp
    if choice == '0'
      options
    end
  end

  def self.delete
    clear_screen
    print "DELETE COURSE"
    print "\nEnter ID:"
    @id = gets.chomp.to_i

    item_included = item_existence(@@record, @id)
    while item_included == false
      puts "\nCourse not found. Enter another value."
      print "Enter ID:"
      @id = gets.chomp.to_i
      item_included = item_existence(@@record, @id)
    end

    if item_included == true
      Course.destroy(@id)
    end

    clear_screen
    puts "Course deleted successfully!"
    exit_management
  end

  def self.edit
    clear_screen
    puts "EDIT DETAILS"
    print "Enter the ID:"
    @id = gets.chomp.to_i

    find_record = @@record.find { |program| program[:id] == @id }

    if find_record.nil?
      puts "Course with ID #{@id} not found."
      print("\n")
      exit_management
      return
    end

    clear_screen
    puts "EDITING RECORD OF #{(find_record[:name].upcase)}"
    print "Enter new name:"
    new_name = gets.chomp
    find_record[:name] = new_name unless new_name.empty?

    puts "\nCourse updated successfully!"
    exit_management
  end

  def self.item_existence(given_array, given_id)
    given_array.any? { |item| item[:id] == given_id }
  end

  def self.clear_screen
    print "\e[H\e[2J"
  end

  def self.options
    clear_screen
    puts "(1) Add Course
(2) Delete Course
(3) Edit Course
(4) View Record
(5) Search Record
(6) Back to School Management"
    print "Enter the number:"
    option = gets.chomp
    case option
    when '1'
      Course.add
    when '2'
      Course.delete
    when '3'
      Course.edit
    when '4'
      Course.all
    when '5'
      Course.find
    when '6'
      clear_screen
      main_loop
    end
  end
end