# We cannot create or call a method with a spaces name in between through a convention way
# However if we use metaprogramming then we can definitely achieve this.

require 'pry-byebug'

class Rsdemo
	def self.create_method_with_space_in_names(desc, &block)
		define_method(desc, &block)
		@examples ||= []
		@examples << desc
	end

	def self.setup
		create_method_with_space_in_names 'test me not' do 
			'do nothing'
		end
	end
end

Rsdemo.setup
puts Rsdemo.public_instance_methods(false)

obj =  Rsdemo.new
puts obj.send(:"test me not")