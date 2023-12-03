class Day3
  include Spliteable

  def initialize(test = false)
    @puzzle = self.class.day_input(3, test)
  end

  def self.go_test
    day3 = Day3.new(true)
    puts day3.sum_parts
  end

  def self.go
    puts Day3.new.sum_parts
  end

  def sum_parts
    sum = 0
    @puzzle.each_with_index do |line, row_index|
      # Extract all the numbers
      nums = line.split(/[^\d]/)
      nums.delete("")

      if nums
        # there is numbers! Check each
        removed = 0
        nums.each do |num|
          puts "Analyzing #{num}"
          num_index = line.index(num)
          if symbol_left?(line, num_index - 1) ||
            symbol_right?(line, num_index + num.length) ||
            symbol_in_other_line?(num_index + removed, num.length, row_index - 1) ||
            symbol_in_other_line?(num_index + removed, num.length, row_index + 1)
            # is a part!
            sum += num.to_i
          end
          line = line[(num_index+num.length)..(line.length - 1)]
          removed += num_index + num.length
        end
      end
    end
    sum
  end

  private

  def symbol_left?(line, index)
    left = index >= 0 && symbol?(line[index])
    left
  end

  def symbol_right?(line, index)
    right = symbol?(line[index])
    right
  end

  def symbol_in_other_line?(index, num_length, row_index)
    return false if row_index < 0
    return false if row_index == @puzzle.length

    line = @puzzle[row_index]
    init = index == 0 ? 0 : index - 1
    stop = index + num_length

    for pos in init..stop do
      return true if symbol?(line[pos])
    end
    false
  end

  def symbol?(element)
    element.present? && element != '.' && !element.match?(/[[:digit:]]/)
  end
end