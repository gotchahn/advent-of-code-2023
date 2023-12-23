class Day18
  include Spliteable

  attr_accessor :lagoon, :instructions, :vertices, :corners

  DIRECTIONS = {
    'R' => {inc_row: 0, inc_col: 1},
    'L' => {inc_row: 0, inc_col: -1},
    'U' => {inc_row: -1, inc_col: 0},
    'D' => {inc_row: 1, inc_col: 0}
  }

  def initialize(test = false)
    @puzzle = self.class.day_input(18, test)
  end

  def self.go(test = false)
    day = Day18.new(test)
    day.start_work
  end

  def start_work
    build_instructions
    dig
  rescue Exception => e
    puts e.message
    puts e.backtrace
  end

  def build_instructions
    @instructions = []

    @puzzle.each do |line|
      vals = line.split(" ")
      direction = vals[0]
      amount = vals[1].to_i
      color = vals[2]

      @instructions.push({direction: direction, amount: amount, color: color})
    end

    @lagoon = [[]]
  end

  def build_vertices
    @vertices = []

    @corners.each do |corner|
      @vertices.push(Geometry::Vector.new(corner[:row_index], corner[:col_index]))
    end
  end

  def dig
    @dig_row = 0
    @dig_col = 0
    @prev_dir = nil
    @corners = []

    @instructions.each do |inst|
      adapt_map(inst)
      dig_rec(0, inst)
    end

    build_vertices

    trenches = 0
    @polygon = Geometry::Polygon.new(@vertices)

    @lagoon.each_with_index do |line, row_index|
      first = line.index('#')
      last = line.rindex('#')
      next unless first && last

      for col_index in first..last do
        case line[col_index]
        when '#'
          trenches += 1
        else
          if @polygon.contains?(Geometry::Point.new(row_index, col_index))
            @lagoon[row_index][col_index] = '~'
            trenches += 1
          end
        end
      end
    end

    print_map
    puts "Polygon COORD: #{@polygon.area}"
    puts "Trenches: #{trenches}"
  end

  def adapt_map(inst)
    current_cols = @lagoon.any? ? @lagoon[0].length : 0
    current_rows = @lagoon.any? && @lagoon[0].any? ? @lagoon.length : 0
    amount = inst[:amount]

    if %w[R L].include?(inst[:direction])
      # cols
      case inst[:direction]
      when "R"
        final_col = @dig_col + amount + 1
        if final_col >= current_cols
          cols  = final_col - current_cols
          increase_cols(false, cols)
        end
      else
        final_col = @dig_col - inst[:amount] - 1
        if final_col < 0
          increase_cols(true, final_col.abs)
        end
      end
    else
      # rows
      case inst[:direction]
      when "U"
        final_row = @dig_row - inst[:amount] - 1
        if final_row < 0
          increase_rows(true, final_row.abs)
        end
      else
        final_row = @dig_row + inst[:amount] + 1
        if final_row >= current_rows
          rows = final_row - current_rows
          increase_rows(false, rows)
        end
      end
    end
  end

  def dig_rec(step, instruction)
    if step < instruction[:amount]

      if @prev_dir != instruction[:direction]
        @lagoon[@dig_row][@dig_col] = '#'
        @corners.push({row_index: @dig_row, col_index: @dig_col})
      else
        @lagoon[@dig_row][@dig_col] = '#'
      end

      @prev_dir = instruction[:direction]

      dir = DIRECTIONS[instruction[:direction]]
      @dig_row += dir[:inc_row]
      @dig_col += dir[:inc_col]

      dig_rec(step + 1, instruction)
    end
  end

  def adapt_corners(row_inc, col_inc)
    @corners.each do |corner|
      corner[:row_index] += row_inc
      corner[:col_index] += col_inc
    end
  end

  def print_map
    puts "\n\n"
    @lagoon.each do |row|
      puts "#{row.join(" ")}"
    end
  end

  def increase_rows(insert, amount)
    if insert
      for r in 1..amount do
        @lagoon.insert(0, ['.'] * @lagoon[0].length)
      end
      @dig_row += amount
      adapt_corners(amount, 0)
    else
      for r in 1..amount do
        @lagoon.push(['.'] * @lagoon[0].length)
      end
    end
  end

  def increase_cols(insert, amount)
    if insert
      @lagoon.each do |row|
        for c in 1..amount do
          row.insert(0, '.')
        end
      end
      @dig_col += amount
      adapt_corners(0, amount)
    else
      @lagoon.each do |row|
        for c in 1..amount do
          row.push('.')
        end
      end
    end
  end
end