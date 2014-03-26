# A simple module with a helper for random alpha strings
module StringHelpers

  def self.random_alpha_string
    ALPHABET.sample(rand(STRING_LENGTH_RANGE)).join('')
  end

  private

  ALPHABET = ('a'..'z').to_a
  STRING_LENGTH_RANGE = (5..15)

end
