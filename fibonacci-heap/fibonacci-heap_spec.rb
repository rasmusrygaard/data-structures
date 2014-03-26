require './fibonacci-heap'

describe FibonacciHeap, '#size' do

  context 'with an empty tree' do

    it 'returns 0' do
      expect(subject.size).to eq(0)
    end

  end

  context 'with elements' do

    let(:num_elems) { 10 }

    before(:each) do
      num_elems.times do |n|
        subject.insert(n)
      end
    end

    it 'returns the right size' do
      subject.size.should == num_elems
    end

    it 'returns the right size after deleting' do
      subject.extract_min
      subject.size.should == num_elems - 1
    end

    it 'returns the right size after inserting' do
      subject.insert(num_elems + 1)
      subject.size.should == num_elems + 1
    end

  end

end
