class Teacher
  attr_accessor :id, :name, :birth_date, :email, :phone_number, :delete_at
  @@record = []
  @@next_id = 1

  def initialize(name, birth_date, email, phone_number, delete_at = nil)
    @id = @@next_id
    @@next_id += 1
    @name = name
    @birth_date = birth_date
    @email = email
    @phone_number = phone_number
    @delete_at = delete_at
  end

  def save
    user_existence = @@record.find { |user| user[:id] == @id }

    if user_existence
      user_existence[:name] = @name
      user_existence[:birth_date] = @birth_date
      user_existence[:email] = @email
      user_existence[:phone_number] = @phone_number
    else
      @@record.append({ id: @id, name: @name, birth_date: @birth_date, email: @email, phone_number: @phone_number, delete_at: @delete_at })
    end
  end

  def self.destroy(id)
    find_record = @@record.find { |user| user[:id] == id }
    if find_record
      find_record[:delete_at] = Time.now
    else
      puts "User with ID #{id} not found."
    end
  end

  def display
    puts "Id: #{@id}\nName: #{@name}\nBirth Date: #{@birth_date}\nEmail: #{@email}\nPhone: #{@phone_number}"
  end

  def self.all
    clear_screen
    puts "VIEW RECORD"
    if @@record.empty?
      puts "\nNo users to display."
    else
      @@record.each_with_index do |user, index_number|
        if user[:delete_at]
          puts "\nTeacher Record #{index_number + 1} is marked as deleted (Deleted at: #{user[:delete_at]})"
        else
          puts "\nTeacher Record #{index_number + 1}\nTeacher_id: #{user[:id]}\nName: #{user[:name]}\nBirthday: #{user[:birth_date]}\nEmail: #{user[:email]}\nPhone Number: #{user[:phone_number]}"
        end
      end
    end
    print("\n")
    exit_management
  end

  def self.find
    clear_screen
    puts "SEARCH USER"
    print "Enter ID: "
    @id = gets.chomp.to_i

    user_existence = @@record.find { |user| user[:id] == @id }

    if user_existence.nil?
      puts "\nUser not found."
      exit_management
      return
    end

    if user_existence[:delete_at]
      puts "\nTeacher Record is marked as deleted (Deleted at: #{user_existence[:delete_at]})"
    else
      clear_screen
      puts "DATA IN THE GIVEN ID"
      puts "Name: #{user_existence[:name]}"
      puts "Birthday: #{user_existence[:birth_date]}"
      puts "Email: #{user_existence[:email]}"
      puts "Phone: #{user_existence[:phone_number]}"
    end

    print("\n")
    exit_management
  end

  def self.find_by_email
    clear_screen
    puts "SEARCH USER"
    print "Enter email: "
    @email = gets.chomp

    user_existence = @@record.find { |user| user[:email] == @email }

    if user_existence.nil?
      puts "\nUser not found."
      return
    end

    if user_existence[:delete_at]
      puts "\nTeacher Record is marked as deleted (Deleted at: #{user_existence[:delete_at]})"
    else
      clear_screen
      puts "DATA IN THE GIVEN EMAIL"
      puts "Name: #{user_existence[:name]}"
      puts "Birthday: #{user_existence[:birth_date]}"
      puts "Email: #{user_existence[:email]}"
      puts "Phone: #{user_existence[:phone_number]}"
    end

    print("\n")
    exit_management
  end

  def self.add
    clear_screen
    puts "ADD TEACHER"

    print "Enter name:"
    @name = gets.chomp
    print "Enter birth date:"
    @birth_date = gets.chomp
    print "Enter email:"
    @email = gets.chomp
    print "Enter phone:"
    @phone_number = gets.chomp
    user = Teacher.new(@name, @birth_date, @email, @phone_number)
    user.save

    clear_screen
    puts "TEACHER DETAILS\n"
    user.display
    puts "\nTeacher added successfully!"
    exit_management
  end

  def self.exit_management
    print "Enter 0 to go back to teacher management."
    choice = gets.chomp
    if choice == '0'
      options
    end
  end

  def self.delete
    clear_screen
    print "DELETE TEACHER"
    print "\nEnter ID:"
    @id = gets.chomp.to_i

    item_included = item_existence(@@record, @id)
    while item_included == false
      puts "\nUser not found. Enter another value."
      print "Enter ID:"
      @id = gets.chomp.to_i
      item_included = item_existence(@@record, @id)
    end

    if item_included == true
      Teacher.destroy(@id)
    end

    clear_screen
    puts "Teacher deleted successfully!"
    exit_management
  end

  def self.edit
    clear_screen
    puts "EDIT DETAILS"
    print "Enter the ID:"
    @id = gets.chomp.to_i

    find_record = @@record.find { |user| user[:id] == @id }

    if find_record.nil?
      puts "Teacher with ID #{@id} not found."
      print("\n")
      exit_management
      return
    end

    clear_screen
    puts "EDITING RECORD OF #{(find_record[:name].upcase)}"
    print "Enter new name:"
    new_name = gets.chomp
    find_record[:name] = new_name unless new_name.empty?
    print "Enter new birth date:"
    new_birth_date = gets.chomp
    find_record[:birth_date] = new_birth_date unless new_birth_date.empty?
    print "Enter new email:"
    new_email = gets.chomp
    find_record[:email] = new_email unless new_email.empty?
    print "Enter new phone number:"
    new_phone = gets.chomp
    find_record[:phone_number] = new_phone unless new_phone.empty?

    puts "\nTeacher updated successfully!"
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
    puts "(1) Add Teacher
(2) Delete Teacher
(3) Edit Teacher
(4) View Record
(5) Search Record
(6) Back to School Management"
    print "Enter the number:"
    option = gets.chomp
    case option
    when '1'
      Teacher.add
    when '2'
      Teacher.delete
    when '3'
      Teacher.edit
    when '4'
      Teacher.all
    when '5'
      clear_screen
      puts "Find by
(1) ID
(2) Email"
      print "\nEnter the number:"
      choice = gets.chomp
      if choice == '1'
        Teacher.find
      elsif choice == '2'
        Teacher.find_by_email
      else
        "\nInvalid input"
      end
    when '6'
      clear_screen
      main_loop
    end
  end
end