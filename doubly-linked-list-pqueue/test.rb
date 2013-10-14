require "./doubly-linked-list-pqueue.rb"

MAX_SIZE = 10000

def build_pqueue(type, data, size)
	pq = type.new
	count = 0
	data.each do |elem|
		pq.insert elem
		count += 1
		break if count == size
	end
	puts "Inserted #{pq.size} words."
	pq
end

def extract_elements(pq)
	puts  "+ Extracting all elements, and confirming they come in alphabetical order."
	puts  "     [You'll see a dot for every 1000 extracted.]"
	print "     "
	least_so_far = 0

	count, num_extractions = 0, pq.size
	while not pq.empty?
		next_elem = pq.extract_min
		if next_elem < least_so_far
			puts "Priority Queue is returning elements in the wrong order."
			puts "Got #{next_elem} not #{least_so_far}"
		end

		least_so_far = next_elem
		count += 1
		if count % 1000 == 0
			print "."
			puts "\n" if count % 40000 == 0
		end
	end

	puts "\n"
	if count != num_extractions
		puts "Expected to extract #{num_extractions} elements but got #{count} instead."
	else
		puts "+ Properly extracted all #{count} elements"
	end
end

def sorted_test(type, size)
	pq = build_pqueue(type, (0..MAX_SIZE), size)
	extract_elements pq
end

def shuffle_test(type, size)
	pq = build_pqueue(type, (0..MAX_SIZE).entries.shuffle, size)
	extract_elements pq
end

def random_test(type, size)
	elems = []
	MAX_SIZE.times do
		elems << (rand * 10000).floor
	end
	pq = build_pqueue(type, elems, size)
	extract_elements pq
end

sorted_test DoublyLinkedListPQueue, 10000
shuffle_test DoublyLinkedListPQueue, 10000
random_test DoublyLinkedListPQueue, 10000
