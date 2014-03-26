require 'spec_helper'

require 'fibonacci-heap/fibonacci-heap'

describe FibonacciHeap do

  let (:heap) { FibonacciHeap.new }

  it_behaves_like "a heap"

end
