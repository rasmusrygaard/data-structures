module Quicksort
  def quicksort!
    return if self.empty? || self.one?

    shuffle!
    rec_quicksort!(0, length)
    self
  end

  def quicksort
    rec_quicksort(self.clone.shuffle)
  end

  private
  def rec_quicksort!(low, high)
    return if low >= high

    pivot_index = partition!(low, high)
    rec_quicksort!(low, pivot_index)
    rec_quicksort!(pivot_index + 1, high)
  end

  def partition!(low, high)
    pivot = self[high - 1]
    left_index = low
    right_index = high - 2

    while left_index <= right_index do
      if self[left_index] >= pivot
        swap!(left_index, right_index)
        right_index -= 1
      else
        left_index += 1
      end
    end
    swap!(high - 1, left_index)

    left_index
  end

  def swap!(a, b)
    self[a], self[b] = self[b], self[a]
  end

  def rec_quicksort(array)
    return array if array.empty? || array.one?

    pivot = array.shift
    partitioned = array.partition { |val| val < pivot }
    rec_quicksort(partitioned.first).concat([pivot]).concat(rec_quicksort(partitioned.last))
  end
end
