require 'spec_helper'

require 'splay-tree/splay-tree'

describe SplayTree do

  let (:subject) { SplayTree.new }

  it_behaves_like "a set"

end
