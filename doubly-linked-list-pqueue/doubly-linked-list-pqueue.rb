class Node
	attr_accessor :left, :right, :data

	def initialize(data)
		@data = data
		@left = @right = nil
	end
end

class DoublyLinkedListPQueue
	attr_accessor :size

	def initialize
		@roots = @min = nil
		@size = 0
	end

	def insert(elem)
		node = Node.new elem
		if @roots.nil?
			@roots = @min = node
			node.right = node.left = node
		else
			node.right = @roots.right
			node.left  = @roots.left
			@roots.right.left = node
			@roots.right = node
		end

		@min = node if node.data < @min.data
		@size += 1
	end

	def extract_min
		if empty?
			puts "extract_min on an empty queue"
		else
			min = remove_min
			find_new_min
			@size -= 1
			min.data
		end
	end

	def empty?
		@size == 0
	end

	private

	# Remove the minimum element from the @roots list and return it.
	def remove_min
		node = @min
		# Remove the minimum node from the list
		node.left.right = node.right
		node.right.left = node.left
		# If the min happens to be the root, get a new root
		if node == @roots
			@roots = node.right
			# If we are removing the only element in the queue, make sure
			# we correctly reset all state.
			@roots = @min = nil if @roots == node
		end
		node
	end

	# Search the @roots list for a new minimum element and update @min
	def find_new_min
		if @roots.nil?
			@min = nil
			return
		end

		cur_min = @roots
		cur = @roots.right
		while true
			if cur.data < cur_min.data
				cur_min = cur
			end
			cur = cur.right
			break if cur == @roots
		end
		@min = cur_min
	end
end
