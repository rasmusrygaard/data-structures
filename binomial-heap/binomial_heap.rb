class BinomialHeap

  attr_accessor :roots

  def initialize(options={})
    @roots = options[:roots] || []
  end

  def insert(value)
    merge(BinomialHeap.new(roots: [BinomialNode.new(value)]))
  end

  def find_min
    return nil if empty?

    @roots[min_index]
  end

  def extract_min
    # First, extract and remove the minimum heap from the list of roots.
    min_root = min_index
    return nil if min_root == -1

    min_node = @roots[min_root]
    @roots[min_root] = nil

    self.merge(min_node.to_binomial_heap)
    min_node.value
  end

  def empty?
    @roots.compact.empty?
  end

  def merge(to_merge)
    order_roots = [@roots, to_merge.roots].sort_by(&:size)
    all_roots = order_roots.last.zip(order_roots.first)

    carry = nil
    all_roots.each_with_index do |(first, second), index|
      # The candidates are the non-nil heaps of the same order.
      candidates = [first, second, carry]
      candidates.compact!
      case candidates.size
      when 3
        # If both first, second, and carry are non-nil, pick one to insert and merge the two
        # remaining heaps as the new carry.
        @roots[index] = candidates.pop
        carry = BinomialNode.merge_same_order(*candidates)
      when 2
        # If only two nodes are non-nil, just merge and let them carry to the next index.
        @roots[index] = nil
        carry = BinomialNode.merge_same_order(*candidates)
      when 1
        # If we only have one candidate heap, just insert it.
        @roots[index] = candidates.first
        carry = nil
      end
    end
    # The carry can only be nil if the last root is at the same index in both heaps.
    # If that is the case, just append it.
    @roots << carry unless carry.nil?
  end

  private
  # Encapsulate a node in the tree. A value along with an Array of children.
  class BinomialNode
    include Comparable

    attr_accessor :value, :children

    def initialize(value)
      @value = value
      @children = []
    end

    # Merge two heaps of the same order.
    # This class method accepts two order N heaps and merges them into a new heap.
    # Note that this method destructively modifies the heap with the smaller root.
    def self.merge_same_order(first, second)
      root, other = *[first, second].sort
      root.children << other
      root
    end

    def <=>(other)
      @value <=> other.value
    end

    # Convert the node to a binomial heap by stripping the root node.
    def to_binomial_heap
      BinomialHeap.new(roots: @children)
    end

  end

  # Return the index of the sub-heap with the smallest root value.
  def min_index
    @roots.each_with_index.inject(-1) do |min_index, (heap, index)|
      # If the current heap is empty, keep the old index.
      next min_index if heap.nil?
      # If the current minimum is the inject default or the current heap has a smaller value, return
      # the current index. Otherwise, return the existing min.
      (min_index == -1 || heap < @roots[min_index]) ? index : min_index
    end
  end
end
