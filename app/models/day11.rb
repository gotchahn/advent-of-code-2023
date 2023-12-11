class Day11
  include Spliteable
  attr_accessor :expansion, :galaxies, :empty_rows, :empty_cols

  def initialize(test = false)
    @puzzle = self.class.day_input(11, test)
  end
  
  def self.go(test = false)
    day = Day11.new(test)
    day.travel(2) # part 1
    day.travel(1000000) # part 2
  end

  def travel(times)
    build_expansion2
    find_galaxies

    sum = 0

    for galaxy in 0..@galaxies.length - 2 do
      for another in (galaxy + 1)..@galaxies.length - 1 do
        another_row = @galaxies[another][0]
        another_col = @galaxies[another][1]
        galaxy_row =  @galaxies[galaxy][0]
        galaxy_col =  @galaxies[galaxy][1]

        diff = (another_row - galaxy_row).abs + (another_col - galaxy_col).abs

        # how many empty rows pass
        empties = 0
        @empty_rows.each do |empty_row|
          if another_row < galaxy_row
            empties += 1 if empty_row.between?(another_row, galaxy_row)
          else
            empties += 1 if empty_row.between?(galaxy_row, another_row)
          end
        end

        @empty_cols.each do |empty_col|
          if another_col < galaxy_col
            empties += 1 if empty_col.between?(another_col, galaxy_col)
          else
            empties += 1 if empty_col.between?(galaxy_col, another_col)
          end
        end

        result = diff + (empties * times) - empties
        sum += result
      end
    end
    puts "Sum of diff: #{sum}"
  end

  def build_expansion2
    @empty_rows = []
    @empty_cols = []
    @expansion = []

    # empty rows
    @puzzle.each_with_index do |line, row|
      chars = line.chars
      @expansion.push(chars)

      if chars.all?{|v| v == '.'}
        @empty_rows.push(row)
      end
    end

    # empty cols
    col = 0
    while col < @puzzle[0].length
      empty = true
      for row in 0..@puzzle.length - 1 do
        if @puzzle[row][col] != '.'
          empty = false
          break
        end
      end

      @empty_cols.push(col) if empty
      col += 1
    end
  end

  def find_galaxies
    @galaxies = []
    @expansion.each_with_index do |line, row_index|
      line.each_with_index do |space, space_index|
        if space == '#'
          @galaxies.push([row_index, space_index])
        end
      end
    end
  end

  private

  def print_universe
    @expansion.each do |line|
      line.each do |val|
        print "#{val} "
      end
      puts ''
    end
  end
end