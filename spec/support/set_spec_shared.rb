shared_examples_for "a set" do
  [
    { type: 'sorted',     items: Proc.new { (1..1000) } },
    { type: 'a few',      items: Proc.new { (1..100) } },
    { type: 'reversed',   items: Proc.new { 1000.downto(1) } },
    { type: 'random',     items: Proc.new { (1..1000).to_a.shuffle } },
  ].each do |test_case|


    context "with #{test_case[:type]} items" do

      let(:reference) { Set.new }
      let(:items) { test_case[:items].call }

      describe '#include?' do
        it_behaves_like 'set#include?'
      end

      describe '#extract_min' do
        it_behaves_like 'set#include?'
      end

    end

  end

end
