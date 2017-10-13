## Enumerables
    
    h = [1, 2, 4, 5, 7, 10]
    h.map{ |e| e * 2 }
    
#collect
  # synonyms to map, returns a array of iterated elems
  h.collect{ |e| e * 2 }
   
#select
 # returns a array of filtered array
 h.select(&:even?)
 
 #longerway
 evens = []
 h.each do |e|
   evens << e if e.even?
 end
 
#reject
 # returns a array of filtered array  
 h.reject(&:odd?)
 
#detect
 #returns a first passed elem
 h.detect(&:even?)
 
#inject
 #uses an accumulator to store result and circulates that for entire range.
  SALARIES = {
      0 => 50_000,
      1 => 70_000,
    }

  salaries.inject(0) do |prev, curr|
    return SALARIES.index(curr) if (prev..curr).cover?(salary)
    curr
  end


# grep 
  # uses regex and returns the result that is passed

# partition
  h.partition(&:even?)
  # [[2, 4, 10], [1, 5, 7]]

# cycles
  # repeats through the array
  h.cycle(2){|e| puts e}

# each_slice
  #creates a group and process it.
 h.each_slice(2){ |e| puts e}

# lazy
  # does not executes this instead it returns a #<Enumerator::Lazy: ...> and acts only when used
 r = (1..1000).lazy.take(6).map{|i| i}
 r.each{|i| p i}





