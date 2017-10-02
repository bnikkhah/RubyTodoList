module Menu
	def menu
		"Choose your option\n1) Add\n2) Show\n3) Delete\n4) Update\n5) Write to file\n6) Read from file\n7) Toggle Status\nQ) Quit\n"
	end

	def show
		menu
	end
end

module Promptable
	def prompt(message = 'What would you like to do?', symbol = ':> ')
		puts message
		print symbol
		gets.chomp
	end
end

class List
	attr_reader :all_tasks

	def initialize
		@all_tasks = []
	end

	def show
		all_tasks.map.with_index{ |l, i| "#{i.next}) #{l}" }
	end

	def add(task)
		all_tasks << task
	end

	def delete(task_number)
		all_tasks.delete_at(task_number-1)
	end

	def update(task_number, task)
		all_tasks[task_number-1] = task
	end

	def write_to_file(file)
		IO.write(file, @all_tasks.map(&:to_machine).join("\n"))
	end

	def toggle(task_number)
		all_tasks[task_number-1].toggle_status
	end

	def read_from_file(file)
		IO.readlines(file).each do |line|
			status, *description = line.split(': ')
			status = status.include?('X')
			add(Task.new(description.join(':').strip, status))
		end 
	end
end

class Task
	attr_reader :description
	attr_accessor :status

	def initialize(description, status = false)
		@description = description
		@status = status
	end

	def completed?
		status
	end

	def to_machine
		"#{represent_status} : #{description}"
	end

	def toggle_status
		@status = !completed?
	end

	def show
		description
	end

	def to_s
		"#{represent_status} : #{description}"
	end

	private

	def represent_status
		"#{completed? ? '[X]' : '[ ]'}" 
	end
end

if __FILE__ == $PROGRAM_NAME
	include Menu
	include Promptable
	my_list = List.new
	puts 'Please choose from the following list'
	until ['q'].include?(user_input = prompt(show).downcase)
		case user_input
		when '1'
			my_list.add(Task.new(prompt('What is the task you would like to accomplish?')))
		when '2'
			puts my_list.show
		when '3'
			puts my_list.show
			my_list.delete(prompt('Which task to remove?').to_i)
		when '4'
			puts my_list.show
			my_list.update(prompt('Which task to update?').to_i, Task.new(prompt('To what? ')))
		when '5'
			my_list.write_to_file(prompt('What file would you like to write it to?'))
		when '6'
			begin
				my_list.read_from_file(prompt('What file would you like to read from?'))
				puts my_list.show
			rescue Errno::ENOENT
				puts 'File name not found, please verify your file name and path'
			end
		when '7'
			puts my_list.show
			my_list.toggle(prompt('Which one to toggle?').to_i)
		else
			puts 'Sorry, I didn\'t understand that'
		end
	end
	puts 'Thanks for using the menu system!'
end