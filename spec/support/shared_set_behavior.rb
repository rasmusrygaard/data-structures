shared_examples "set#insert" do

  it 'inserts elements' do
    expect {
      items.each { |item| subject.insert(item) }
    }.to_not raise_error
  end

end

shared_examples 'set#empty?' do

  it 'returns true on an empty set' do
    expect(subject.empty?).to be_true
  end

  it 'returns false for single element sets' do
    subject.insert(42)
    expect(subject.empty?).to be_false
  end

  it 'returns true after deleting last element' do
    subject.insert(42)
    subject.delete(42)
    expect(subject.empty?).to be_true
  end

end

shared_examples 'set#include?' do

  it 'returns false on an empty heap' do
    items.each do |item|
      expect(subject.include?(item)).to be_false
    end
  end

  context 'with all elements inserted' do

    include_context 'with all elements in set'

    it 'contains all elements' do
      items.each do |item|
        expect(subject.include?(item)).to eq(reference.include?(item))
      end
    end

  end

  context 'with iterated insertion' do

    it 'extracts elements in order' do
      all_items = items.to_a
      items_array = all_items.reverse
      insert_fracs = [0.2, 0.2, 0.2, 0.2, 0.2]
      extract_frac = [0.1, 0.2, 0.2, 0.2, 0.3]

      insert_fracs.zip(extract_frac).each do |insert_frac, extract_frac|
        # First, grab the elements we want to insert and delete
        items_in_ref = reference.to_a
        to_delete = items_in_ref.sample((extract_frac  * items_array.length).to_i)
        to_insert = items_array.pop((insert_frac  * items_array.length).to_i)

        # Then, insert/remove elements in both subject and reference.
        to_insert.each do |elem|
          subject.insert(elem)
          reference.add(elem)
        end

        to_delete.each do |elem|
          subject.delete(elem)
          reference.delete(elem)
        end

        # Finally, make sure that the reference and the subject agree on all elements, not just
        # the ones currently in the set.
        all_items.each do |item|
          expect(subject.include?(item)).to eq(reference.include?(item))
        end
      end
    end

  end


end

# Run a before block that inserts elements into the heap
shared_context 'with all elements in set' do

  before(:each) do
    items.each do |item|
      subject.insert(item)
      reference.add(item)
    end
  end

end
