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
 



# grep 
  # uses regex and returns the result that is passed

# partition
  h.partition(&:even?)
  # [[2, 4, 10], [1, 5, 7]]
