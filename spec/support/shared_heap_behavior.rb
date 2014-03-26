shared_examples "heap#insert" do

  it 'inserts elements' do
    expect {
      items.each { |item| heap.insert(item) }
    }.to_not raise_error
  end

end

shared_examples 'heap#extract_min' do

  it 'returns nil on an empty heap' do
    expect(heap.extract_min).to eq(reference.extract_min)
  end

  context 'with all elements inserted' do

    include_context 'with all elements in heap'

    it 'extracts elements in order' do
      while !reference.empty?
        expect(heap.extract_min).to eq(reference.extract_min)
      end
    end

  end

  context 'with iterated insertion' do

    it 'extracts elements in order' do
      items_array = items.to_a.reverse
      insert_fracs = [0.2, 0.2, 0.2, 0.2, 0.2]
      extract_frac = [0.1, 0.2, 0.2, 0.2, 0.3]
      insert_fracs.zip(extract_frac).each do |insert_frac, extract_frac|
        # First, grab the elements we want to insert.
        num_to_extract = (extract_frac  * items_array.length).to_i
        to_insert = items_array.pop((insert_frac  * items_array.length).to_i)

        # Then, insert the elements into our contents array and sort them.
        to_insert.each do |elem|
          heap.insert(elem)
          reference.insert(elem)
        end

        # Finally, extract the elements from the heap and and the sorted contents.
        num_to_extract.times do
          expect(heap.extract_min).to eq(reference.extract_min)
        end
      end
    end

  end


end

shared_examples 'heap#peek' do



end

# Run a before block that inserts elements into the heap
shared_context 'with all elements in heap' do

  before(:each) do
    items.each do |item|
      heap.insert(item)
      reference.insert(item)
    end
  end

end
