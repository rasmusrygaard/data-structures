require 'trie/trie'

class Lexicon

  def initialize
    @trie = Trie.new
  end

  def insert(key)
    @trie.insert(key, true)
  end

  def delete(key)
    @trie.remove(key)
  end

  def include_prefix?(prefix)
    @trie.contains_prefix?(prefix)
  end

  def include?(key)
    @trie.contains?(key)
  end

  def empty?
    @trie.empty?
  end

end
