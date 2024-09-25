class Subject
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
    subject_existence = @@record.find { |program| program[:id] == @id }

    if subject_existence
      subject_existence[:name] = @name
    else
      @@record.append({ id: @id, name: @name, delete_at: @delete_at })
    end
  end

  def self.destroy(id)
    find_record = @@record.find { |program| program[:id] == id }
    if find_record
      find_record[:delete_at] = Time.now
    else
      puts "Subject with ID #{id} not found."
    end
  end

  def display
    puts "Id: #{@id}\nName: #{@name}"
  end

  def self.all
    clear_screen
    puts "VIEW RECORD"
    if @@record.empty?
      puts "\nNo subject to display."
    else
      @@record.each_with_index do |program, index_number|
        if program[:delete_at]
          puts "\nSubject Record #{index_number + 1} is marked as deleted (Deleted at: #{program[:delete_at]})"
        else
          puts "\nSubject Record #{index_number + 1}\nSubject_id: #{program[:id]}\nName: #{program[:name]}"
        end
      end
    end
    print("\n")
    exit_management
  end

  def self.find
    clear_screen
    puts "SEARCH SUBJECT"
    print "Enter ID: "
    @id = gets.chomp.to_i

    subject_existence = @@record.find { |program| program[:id] == @id }

    if subject_existence.nil?
      puts "\nSubject not found."
      exit_management
      return
    end

    if subject_existence[:delete_at]
      puts "\nSubject Record is marked as deleted (Deleted at: #{subject_existence[:delete_at]})"
    else
      clear_screen
      puts "DATA IN THE GIVEN ID"
      puts "Name: #{subject_existence[:name]}"
    end

    print("\n")
    exit_management
  end

  def self.add
    clear_screen
    puts "ADD SUBJECT"

    print "Enter name:"
    @name = gets.chomp
    subject = Subject.new(@name)
    subject.save

    clear_screen
    puts "SUBJECT DETAILS\n"
    subject.display
    puts "\nSubject added successfully!"
    exit_management
  end

  def self.exit_management
    print "Enter 0 to go back to subject management."
    choice = gets.chomp
    if choice == '0'
      options
    end
  end

  def self.delete
    clear_screen
    print "DELETE SUBJECT"
    print "\nEnter ID:"
    @id = gets.chomp.to_i

    item_included = item_existence(@@record, @id)
    while item_included == false
      puts "\nSubject not found. Enter another value."
      print "Enter ID:"
      @id = gets.chomp.to_i
      item_included = item_existence(@@record, @id)
    end

    if item_included == true
      Subject.destroy(@id)
    end

    clear_screen
    puts "Subject deleted successfully!"
    exit_management
  end

  def self.edit
    clear_screen
    puts "EDIT DETAILS"
    print "Enter the ID:"
    @id = gets.chomp.to_i

    find_record = @@record.find { |program| program[:id] == @id }

    if find_record.nil?
      puts "Subject with ID #{@id} not found."
      print("\n")
      exit_management
      return
    end

    clear_screen
    puts "EDITING RECORD OF #{(find_record[:name].upcase)}"
    print "Enter new name:"
    new_name = gets.chomp
    find_record[:name] = new_name unless new_name.empty?

    puts "\nSubject updated successfully!"
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
    puts "(1) Add Subject
(2) Delete Subject
(3) Edit Subject
(4) View Record
(5) Search Record
(6) Back to School Management"
    print "Enter the number:"
    option = gets.chomp
    case option
    when '1'
      Subject.add
    when '2'
      Subject.delete
    when '3'
      Subject.edit
    when '4'
      Subject.all
    when '5'
      Subject.find
    when '6'
      clear_screen
      main_loop
    end
  end
end