require "./data"
require "pry-byebug"

# From http://ruby-doc.org/core-2.4.1/Module.html#method-i-define_method
# Defines an instance method in the receiver. The method parameter can be a Proc, a Method or an UnboundMethod object.
# If a block is specified, it is used as the method body. This block is evaluated using instance_eval, a point that is
# tricky to demonstrate because define_method is private. (This is why we resort to the send hack in this example.)

# Read ruby_beyond_basic.rb from line 212 to 232 for better understanding

class DinosaurSimple
    def self.add_method(method_name)
        define_method(method_name) do 
            "this is define_method"
        end
    end
end

DinosaurSimple.add_method(:my_method)
d = DinosaurSimple.new
puts d.my_method


class Dinosaur
    def self.add_attribute(method_name, value)
        define_method(method_name) do 
            value
        end
    end

    def initialize(data)
        data.each do |key, value|
            self.class.add_attribute(key, value)
        end
    end

    # #Simple matcher
    # def self.match_on(attr_name)
    #   # binding.pry
    #   method_name = "match_#{attr_name}"
    #   define_method(method_name) do |value|
    #     attr = self.send(attr_name)
    #     attr == value
    #   end
    # end

    #Complex matcher
    def self.match_on(attr_name, &block)
      method_name = "match_#{attr_name}"
      # if block provided use that else create a default one and use that
      matcher = block || -> attr, value { attr == value}
      define_method(method_name) do |value|
        attr = self.send(attr_name)
        # matcher.call(attr, value)
        matcher[attr, value]
      end
    end

    def self.match_on_atleast(attr_name, threshold)
      binding.pry
      self.match_on(attr_name) do |_,value|
        value >= threshold
      end
    end


end

t_rex = Dinosaur.new(TREX_DATA)
p t_rex.name
p t_rex.hobbies

# Way 1
# class Diplodocus < Dinosaur
  
#   def match_diet(diet)
#     self.diet = diet
#   end

# end

# Way 2
class Diplodocus < Dinosaur
  match_on :diet

  # example of complex matching
  match_on :hobbies do |our_hobbies, other_hobbies|
    (our_hobbies & other_hobbies).any? 
  end


end

puts "----------------------------------------------------"

diplodocus = Diplodocus.new(DIPLODOCUS_DATA)
puts diplodocus.match_diet("herbivore")

puts "------------Complex matching--------------"

class Tyranosaurus < Dinosaur
  match_on :diet

  # example of complex matching
  match_on :hobbies do |our_hobbies, other_hobbies|
    (our_hobbies & other_hobbies).any? 
  end

  #match_on_atleast(:length, 4000) works
  match_on_atleast :length, 4000
end

t = Tyranosaurus.new(TREX_DATA)
puts t.match_hobbies(["Scaring children"])
puts t.match_length(3000)
