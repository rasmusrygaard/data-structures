# A class to encapsulate a single node in the splay tree.
class TreeNode
  attr_accessor :left, :right, :value

  def initialize(value, left=nil, right=nil)
    @value = value
    @left = left
    @right = right
  end
end

# A class representing a splay tree.
class SplayTree
  attr_accessor :header

  def initialize
    @size = 0
    @root = nil
    @header = TreeNode.new(nil)
  end

  # Insert VALUE into the tree.
  def insert(value)
    @size += 1
    if empty?
      @root = TreeNode.new(value)
      return
    end

    # Attempt to bring the new value to the top of the tree.
    splay(value)
    # If value is @root, it must already be in the tree
    return if not empty? and @root.value == value

    # Otherwise, we need to insert a new root.
    new_root = TreeNode.new(value)
    if empty?
      # This value will be the new root if the tree is empty.
      @root = new_root
    elsif new_root.value > @root.value
      # If the element is larger than the old root, @root becomes the left child of the new root.
      new_root.left = @root
      new_root.right = @root.right
      @root.right = nil
    else
      # Alternatively, @root becomes new_root's left child.
      new_root.right = @root
      new_root.left = @root.left
      @root.left = nil
    end
    @root = new_root
  end

  def delete(value)
    return false if empty?
    splay(value)

    # If value doesn't match the root's value, it is not in the tree
    return false if @root.value != value

    # We need to make the maximum
    right_subtree = @root.right
    @root = @root.left
    # Bring the maximum element to the root of the tree
    splay(Float::INFINITY)
    @root.right = right_subtree

    @size -= 1
  end

  # Returns true if the tree contains VALUE.
  def contains?(value)
    return false if empty?
    splay(value)
    @root.value == value
  end

  def empty?
    @root.nil?
  end

  def size
    @size
  end

  private

  def splay(value)
    # Left and right contain nodes less than or greater than value.
    left = right = @header
    cur = @root
    # Use the @header node to easily rewire left and right tree later.
    @header.left = @header.right = nil
    # Descend until cur is the element we are splaying or nil.
    while true
      # No point in splaying if we don't have any nodes left
      if value < cur.value      # Left
        break if cur.left.nil?
        if value < cur.left.value   # Zig-Zig
          cur = SplayTree.rotate_right(cur)
          break if cur.left.nil?
        end
        # We need to remove cur and its right subtree.
        # Point the bottom of the right subtree to cur
        right.left = cur
        # Then move the right pointer down the subtree
        right = cur
        # Finally, cur moves down the tree
        cur = cur.left
      elsif value > cur.value     # Right
        break if cur.right.nil?
        if value > cur.right.value  # Zag-Zag
          cur = SplayTree.rotate_left cur
          break if cur.right.nil?
        end
        # We need to remove cur and its left subtree.
        # Point the bottom of the left subtree to cur
        left.right = cur
        # Then move the left pointer down the subtree
        left = cur
        # Finally, cur moves down the tree
        cur = cur.right
      else
        break
      end
    end
    left.right = cur.left
    right.left = cur.right
    cur.left = header.right
    cur.right = header.left
    @root = cur
  end

  # Insert SUBTREE as the left child of the smallest element in TREE.
  def self.append_min(tree, subtree)
    return subtree if tree.nil?
    min, _ = SplayTree.extreme_and_parent(tree, false)
    min.left = subtree
  end

  # Insert SUBTREE as the right child of the largest element in TREE.
  def self.append_max(tree, subtree)
    return subtree if tree.nil?
    max, _ = SplayTree.extreme_and_parent(tree, false)
    max.right = subtree
  end

  # Remove the maximum node in tree. Assumes that tree is not nil.
  # Rewires the pointers such that the left subtree of the maximum node
  # is now the right subtree of the parent of the current max.
  def self.delete_max(tree)
    max, parent = SplayTree.extreme_and_parent(tree, false)
    parent.right = max.left
    max
  end

  # Return either the min or max element of TREE and its parent. If MIN is true, we search for
  # the smallest element, otherwise we search for the greates.
  # If the node to search for happens to be the root, the parent node will be nil.
  def self.extreme_and_parent(tree, min)
    cur, parent = tree, nil
    while not cur.left.nil?
      parent, cur = cur, min ? cur.left : cur.right
    end
    return cur, parent
  end

  # Rotate TREE left. This makes TREE's right child the new root.
  # Note that this method does not update @root.
  def self.rotate_left(tree)
    new_root = tree.right
    tree.right = new_root.left
    new_root.left = tree
    new_root
  end

  # Rotate TREE right. This makes TREE's left child the new root.
  # Note that this method does not update @root.
  def self.rotate_right(tree)
    new_root = tree.left
    tree.left = new_root.right
    new_root.right = tree
    new_root
  end
end
