require 'spec_helper'

require 'trie/lexicon'

describe Lexicon do

  let (:subject) { Lexicon.new }

  it_behaves_like "a lexicon"

end
