shared_examples_for "a lexicon" do

  [
    { type: 'a few',            items: 100.times.map { StringHelpers.random_alpha_string } },
    { type: 'a fair amount of', items: 1000.times.map { StringHelpers.random_alpha_string } },
    { type: 'a ton of',         items: 10000.times.map { StringHelpers.random_alpha_string } },
  ].each do |test_case|


    context "with #{test_case[:type]} items" do

      let(:reference) { Set.new }
      let(:items) { test_case[:items] }

      describe '#include?' do
        include StringHelpers
        it_behaves_like 'set#include?'
      end

      describe '#empty?' do
        include StringHelpers
        it_behaves_like 'set#empty?'
      end

    end

  end

end
