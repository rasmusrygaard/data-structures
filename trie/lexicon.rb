require './trie.rb'

class Lexicon

  def initialize
    @trie = Trie.new
  end

  def insert(key)
    @trie.insert(key, true)
  end

  def remove(key)
    @trie.remove(key)
  end

  def contains_prefix?(prefix)
    @trie.contains_prefix?(prefix)
  end

  def contains(key)
    @trie.contains?(key)
  end

end