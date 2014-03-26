shared_examples_for "a heap" do
  [
    { type: 'sorted',     items: Proc.new { (1..1000) } },
    { type: 'a few',      items: Proc.new { (1..100) } },
    { type: 'reversed',   items: Proc.new { 1000.downto(1) } },
    { type: 'random',     items: Proc.new { (1..1000).to_a.shuffle } },
    { type: 'many random',items: Proc.new { (1..10000).to_a.shuffle } },
  ].each do |test_case|

    context "with #{test_case[:type]} items" do

      # The simplest possible PQueue representation.
      class UnsortedVectorHeap

        def initialize
          @elems = []
        end

        def insert(e)
          @elems.push(e)
          @sorted = false
        end

        def extract_min
          unless @sorted
            @elems.sort!
            @sorted = true
          end
          @elems.shift
        end

        def peek
          @elems.first
        end

        def size
          @elems.size
        end

        def empty?
          size == 0
        end

      end

      let(:reference) { UnsortedVectorHeap.new }
      let(:items) { test_case[:items].call }

      describe '#insert' do
        it_behaves_like 'heap#insert'
      end

      describe '#extract_min' do
        it_behaves_like 'heap#extract_min'
      end

    end

  end

end
