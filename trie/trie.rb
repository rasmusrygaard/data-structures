class Trie
  def initialize
    @root = TrieNode.new
  end

  def insert(key, value)
    raise ArgumentError unless key.is_a? String
    node, _ = path(key, true)
    node.data = value
  end

  def remove(key)
    node, path = path(key)
    # If node is nil, key was not in the trie.
    return false if node.nil?

    # Otherwise, we have to clean up the trie.
    # In particular, we should clear any node does not point to any non-nil children.
    path.zip(key.chars).reverse_each do |parent, letter|
      # If the node contains pointers, we can stop our walk.
      break unless parent[letter].empty?      
      # Otherwise, we should mark the pointer as invalid.
      parent[letter] = nil
    end

    # If we get to this point, we must have removed a node, so we can return true.
    true
  end

  def find(key)
    node, path = path(key)
    node.nil? ? nil : node.data
  end

  def contains?(key)
    node, _ = path(key)
    (not node.nil?) && (not node.data.nil?)
  end

  def contains_prefix?(prefix)
    node, _ = path(key)
    not node.nil?
  end


  private
  def path(word, should_create=false)
    path = []
    node = @root
    word.each_char do |letter|
      # What happens if we hit a nil node?
      if node[letter].nil?
        # We either create a new one.
        if should_create
          node[letter] = TrieNode.new
        # Or we give up and return the path so far. 
        else
          return nil, path
        end
      end
      # We then extend the path with the give node.
      path << node
      # And descend down the tree.
      node = node[letter]
    end
    return node, path
  end

  class TrieNode
    attr_accessor :data

    ALPHABET_SIZE = 26

    def initialize
      @letters = Array.new(ALPHABET_SIZE)
      @data = nil
    end

    def [](letter)
      alphabet_index = get_index(letter)
      @letters[alphabet_index]
    end

    def []=(letter, value)
      alphabet_index = get_index(letter)
      @letters[alphabet_index] = value
    end

    def empty?
      @letters.all?(&:nil?)
    end

    private
    def get_index(letter)
      letter = letter.downcase! || letter
      alphabet_index = letter.ord - 'a'.ord
      if (alphabet_index < 0 || alphabet_index >= ALPHABET_SIZE)
        raise ArgumentError, "Index out of bounds: #{letter}"
      end
      alphabet_index
    end
  end
end