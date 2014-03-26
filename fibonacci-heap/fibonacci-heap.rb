class Node
  attr_accessor :left, :right, :data, :children

  def initialize(data)
    @data = data
    @left = @right = nil
    @children = []
  end

  def leaf?
    @children.empty?
  end
end

DEBUG = false

class FibonacciHeap
  attr_accessor :size

  def initialize
    @roots = @min = nil
    @size = 0
  end

  def insert(elem)
    node = Node.new elem
    if @roots.nil?
      # Update the bookkeeping if we are inserting the first node.
      @roots = @min = node
      # Make the doubly linked list cyclic.
      node.right = node.left = node
    else
      insert_root node

      # Update the @min pointer if we get a new smallest element.
      @min = node if node.data < @min.data
    end

    @size += 1
  end

  def extract_min
    if empty?
      nil
    else
      min = remove_min
      @size -= 1
      find_new_min

      min.data
    end
  end

  def empty?
    @size == 0
  end

  private

  # Remove the minimum element from the @roots list and return it.
  def remove_min
    min = remove_node @min

    # Before we can remove the node, we need to move its children.
    # We do this by inserting them as new roots in the @roots list.
    insert_children_as_roots min

    # Now we have a large number of roots, which is inefficient.
    # To solve this problem, we consolidate roots into larger trees.
    consolidate_roots

    # Finally, we return the old minimum element
    min
  end

  def remove_node(node)
    to_return = node
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
    to_return
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

  # Insert the node in the @roots list.
  # In particular, make it the element immediately to the right of @roots.
  def insert_root(node)
    if @roots.nil?
      @roots = node
      node.left = node.right = node
      return
    end
    node.right = @roots.right
    node.left  = @roots
    @roots.right.left = node
    @roots.right = node
  end

  # Insert the children of node into the @roots list
  def insert_children_as_roots(node)
    node.children.each do |child|
      insert_root child
    end
  end

  def consolidate_roots
    # No point in wasting our time consolidating an empty heap.
    return if @roots.nil?

    # The number of distinct ranks cannot exceed the log of the number of
    # elements.
    ranks = Array.new @size # Math.log2(@size).ceil
    # Start to the right of roots.
    cur = @roots

    # Note that we could skip the body in the case where we only have a
    # single elemen in @roots. If that is the case, however, there are no
    # roots to consolidate anyway.
    while true
      rank = cur.children.size

      if ranks[rank].nil?
        # If no heap shares this rank, mark this heap as the only one
        # of this rank.
        ranks[rank] = cur
      elsif ranks[rank] != cur
        # Otherwise, we have to merge the two heaps.

        # We need to iteratively merge heaps since the merged heap could
        # have a rank that is shared with another heap.
        while not ranks[rank].nil?
          # Construct a new heap such that the smaller heap root is
          # the root of the new heap and the other root is a child.
          other = ranks[rank]
          new_heap_root = other.data < cur.data ? other : cur
          if new_heap_root == other
            other.children << cur
            remove_node cur

          else
            cur.children << other
            remove_node other
          end
          # Now the rank of the heap has increased by one, so we can
          # remove the old rank pointer and insert our new heap.
          ranks[rank] = nil
          cur = new_heap_root
          rank += 1
        end

        ranks[rank] = cur
      end

      cur = cur.right
      break if cur == @roots
    end
  end

end
