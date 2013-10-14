require './splay-tree.rb'
require 'set'

MAX_VALUE = 1000000

t = SplayTree.new
reference = Set.new

puts "Inserting elements"
10000.times do
  value = (rand() * MAX_VALUE).floor
  t.insert value
  reference.add value
end

puts "Verifying insertion"
reference.each do |elem|
  if not t.contains? elem
    puts "SplayTree does not contain #{elem}"
  end
end

random_order = reference.to_a.shuffle.take 50
random_order.each do |elem|
  puts "Removing element #{elem}"
  t.delete elem
  reference.delete elem
  reference.each do |e|
    if not t.contains? e
      puts "SplayTree does not contain #{e} after deleting #{elem}"
    end
  end
end
