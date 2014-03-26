require 'spec_helper'

require 'binomial-heap/binomial_heap'

describe BinomialHeap do

  let (:heap) { BinomialHeap.new }

  it_behaves_like "a heap"

end
