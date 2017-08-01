prices = [100,75,90,80,50]

def apply_discount(prices)
    discounted_prices = []
    prices.each do |price|
        reduced_price = price - (price * 0.15)
        discounted_prices << reduced_price
    end
    discounted_prices
end

p apply_discount(prices)

def add_tax(prices)
    prices_with_taxes = []
    prices.each do |price|
        tax_and_price = price + (price * 0.2)
        prices_with_taxes << tax_and_price
    end
    prices_with_taxes
end

p add_tax(prices)

#above two methods are simmiliar with only few difference
#lets make our own map functions

discount = Proc.new do |price|
    price - (price * 0.15)
end


def map(list, fn)
    result = []
    list.each do |item|
        result << fn.call(item)
    end
    result
end


p map(prices, discount)

tax = Proc.new do |price|
    price + ( price *0.20 )
end

p map(prices, tax)


# Take a look at built in map function which is much 
# nicer


p prices.map(&discount)
p prices.map(&tax)

# Above are the way where we created a Proc object
# and passes that to map(higher order function).
# but this we seldomly used in ruby
#instead we use a block

## BLOCKS


block = prices.map do |p|
    p + (p * 0.2)
end

p "using block #{block}"


# to use a block, there are two additional bit that 
# ruby need to support for block

# 1 block_given?
# 2 yield ... stops our method and and runs block of code passed

def called_with_block?
    if block_given?
        p "You called me with a block"
    end
end


called_with_block?
called_with_block? do 
    p "passed a block"
end

p "-----------------------------------"

def print_and_yield
    p "before calling yield"
    yield
    p "after calling yield"
end


 print_and_yield do 
    p "Im block"
 end

# we can pass pass data to block using yield
# our version of each 

def each_in_list(list)
    for i in 0..(list.length - 1)
        yield list[i]
    end
end

p "-----------------------------------"

each_in_list([1,2,3,4,5]) do |i|
    p i * 2
end

p "-----------------------------------"

#using yield to return a value from a block


def map_words(input)
    results = []
    input.split.each do |word|
        results << yield(word)
    end
    results
end



# p "-----------------------------------"

res = map_words("My name is John") do |word|
    word.size
end
p res

# Procs versus Block

p "Procs versus Block"

#way of specifying block

np = prices.select do |price|
    price < 80
end
p np

np = prices.select {|price| price < 80 } # use single line
p np


#ways to create and call Procs

p "ways to call Procs, Proc do not check for nos of parameters passed"

cheap = Proc.new do |price|
    price < 50
end
#or
cheap1 = Proc.new { |price| price < 50}

#call as 

p cheap.call(100)
p cheap[100]
p cheap.(100)

p "Create lambdas, check nos of parameters"

#way 1
cheap = lambda { |price| price < 30 }
p cheap.call(50)

#way 2 ruby 1.9+
cheap = -> price { price < 30 }
p cheap.call(20)
p cheap[20]

cheap = -> (price) { price < 30 }
p cheap[50]

# cheapest = -> price1, price2 { [price1, price2].min}
cheapest = -> (price1, price2) { [price1, price2].min}
p cheapest[30,53]

#Called as stabby lamdas

#switching to block again, we can assign block to a parameter
# using special syntax. We can specify an optional
# final parameter to hold the block prefixed by ampersand

def modify_prices(prices, &block)
    p block.inspect
end

prices = [10,400,50]

modify_prices(prices) { |p| p * 1.2 }
add_tax = -> p { p * 1.2 }

# modify_prices(prices, add_tax)
#Above will raise an (ArgumentError) execption
#so use lamdas as, however no one use this way

modify_prices(prices, &add_tax)

#There is a special to_proc method defined on symbols that converts
# symbols to proc
p :even?.to_proc
p :even?.to_proc[21]
# p :even?.to_proc["Hello"] # This will fail 

# It is shorthand way of creating a Proc 
# that just call this message on the value



prices = [75,50,12]

e_p = prices.select{ |p| p.even?}
p e_p

e_p = prices.select(&:even?)
p e_p

# Here ampersand is doing to thing
# First it is calling to_proc on the symbol for us, and
# also it tells ruby that this Proc will act like a block
# being passed to the method, This is a very succinct way
# of calling a single method on a list of objects

#Usability
# Use Proc when we want to execute later, otherwise default choice
# is lambdas
# When we have only one method to execute use &:symbol


#CURRING

mult = -> x,y {x*y}

double = mult.curry[2]
p double[2]



class Promotion
    def initialize(description, calculator)
        @description = description
        @calculator = calculator
    end

    def apply(total)
        total - @calculator[total]
    end
end

discount = Promotion.new(
        "15% of everything",
        -> total { total * 0.15 }
    )

p discount.apply(45) # this is traditional way of invoating lambda



ten_pc = Promotion.new(
        "10% if you spend over $50",
        -> total { total > 50 ? total * 0.1 : 0}
    )

p ten_pc.apply(100) # this is traditional way of invoating lambda


# Lets create a general calculator to demeonstrate curring
calc = -> threshold, discount, total do
    total > threshold ? total*discount : 0
end


ten_pc_calc = calc.curry[50,0.1]
#check if that works
p ten_pc_calc[100]

# use that curried function

ten_pc = Promotion.new(
        "10% if you spend over $50",
        ten_pc_calc
    )

p ten_pc.apply(100)
























