class Day10
  include Spliteable

  attr_accessor :max, :visited, :vertices

  # | going down to down OR up to Up
  # - going right to right, OR left to left
  # J Going right to up, OR down to left
  # F Going up to right, OR left to down
  # L Going down to right, OR left to up
  # 7 Going right to down, OR up to left
  #

  PIPES = {
    '|' => { 'down' => 'down', 'up' => 'up' },
    '-' => { 'right' => 'right', 'left' => 'left' },
    'F' => { 'up' => 'right', 'left' => 'down' },
    'J' => { 'right' => 'up', 'down' => 'left' },
    'L' => { 'down' => 'right', 'left' => 'up' },
    '7' => { 'right' => 'down', 'up' => 'left' }
  }

  def initialize(test = false)
    @puzzle = self.class.day_input(10, test)
  end

  def self.go(test = false)
    day = Day10.new(test)
    day.farthest
    day.enclosed
  end

  def farthest
    @max = 0
    @vertices = []
    init_visited
    @marked = {}
    # find S first
    @puzzle.each_with_index do |line, index|
      found_s = line.index('S')
      if found_s.present?
        @visited[index][found_s] = '0'
        coord = "#{index},#{found_s}"
        @marked[coord] = true
        @vertices.push(Geometry::Vector.new(index, found_s))

        sr=pipe2(index, found_s + 1, 1, 'right') #right
        sl=pipe2(index, found_s - 1, 1, 'left') #left
        su=pipe2(index - 1, found_s, 1, 'up') #up
        sd=pipe2(index + 1, found_s, 1, 'down') #down

        print_puzzle
        puts "Farthest: #{[sr, su, sd, sl].max}"

        # stop searching for S
        break
      end
    end
  end

  def pipe(row, col, step, direction)
    return step - 1 if row < 0 || row >= @puzzle.length
    line = @puzzle[row]
    return step - 1 if col < 0 || col >= line.length
    cell = line[col]

    return step - 1 if cell == '.'
    return step if cell == 'S'
    coord = "#{row},#{col}"
    return step - 1 if @marked[coord]
    pipe = PIPES[cell]
    return step - 1 unless pipe[direction].present?

    @visited[row][col] = step.to_s
    @marked[coord] = true
    sr = 0
    su = 0
    sd = 0
    sl = 0
    next_direction = pipe[direction]
    puts "I come from #{direction} and Next Direction is #{next_direction}"

    if next_direction == 'right'
      sr = pipe(row, col + 1, step + 1, 'right')
    elsif next_direction == 'up'
      su = pipe(row - 1, col, step + 1, 'up')
    elsif next_direction == 'down'
      sd = pipe(row + 1, col, step + 1, 'down')
    elsif next_direction == 'left'
      sl = pipe(row, col - 1, step + 1, 'left')
    end

    return [sr, su, sd, sl].max
  end

  def pipe2(row, col, step, direction)
    while true
      if row < 0 || row >= @puzzle.length
        #step -= 1
        break
      end

      line = @puzzle[row]
      if col < 0 || col >= line.length
        #step - 1
        break
      end

      cell = line[col]

      if cell == '.'
        break
      end
      break if cell == 'S'

      coord = "#{row},#{col}"
      if @marked[coord]
        break
      end

      pipe = PIPES[cell]
      unless pipe[direction].present?
        #step -= 1
        break
      end

      @visited[row][col] = step.to_s
      @marked[coord] = true

      next_direction = pipe[direction]
      puts "I come from #{direction} and Next Direction is #{next_direction}"
      if direction != next_direction
        @vertices.push(Geometry::Vector.new(row, col))
      end

      if next_direction == 'right'
        step += 1
        col += 1
      elsif next_direction == 'up'
        row -= 1
        step += 1
      elsif next_direction == 'down'
        row += 1
        step += 1
      elsif next_direction == 'left'
        col -= 1
        step += 1
      end
      direction = next_direction
    end
    step
  end

  def enclosed
    enclose = 0
    @polygon = Geometry::Polygon.new(@vertices)

    @puzzle.each_with_index do |line, row_index|
      line.chars.each_with_index do |col, col_index|
        coord = "#{row_index},#{col_index}"
        if @marked[coord]
          next
        end
        enclose += 1 if @polygon.contains?(Geometry::Point.new(row_index, col_index))
      end
    end
    puts "Tile enclosed: #{enclose}"
  end

  private

  def init_visited
    @visited = []
    @puzzle.each do |line|
      @visited.push(line.chars)
    end
  end

  def print_puzzle
    @visited.each do |line|
      line.each do |val|
        print "#{val} "
      end
      puts ''
    end
  end
end