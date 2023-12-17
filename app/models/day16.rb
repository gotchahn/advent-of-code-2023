class Day16
  include Spliteable
  attr_accessor :visited, :tiles, :beans

  DIRECTIONS = {
    'right' => {inc_row: 0, inc_col: 1},
    'left' => {inc_row: 0, inc_col: -1},
    'up' => {inc_row: -1, inc_col: 0},
    'down' => {inc_row: 1, inc_col: 0}
  }

  MIRRORS = {
    'upward' => { 'right' => 'up', 'up' => 'right', 'down' => 'left', 'left' => 'down' },
    'downward' => { 'right' => 'down', 'up' => 'left', 'down' => 'right', 'left' => 'up' }
  }

  def initialize(test = false)
    @puzzle = self.class.day_input(16, test)
  end

  def self.go(test = false)
    day = Day16.new(test)
    day.beamify
  end

  def beamify
    energized_tiles = []

    col = 0
    while col < @puzzle[0].length
      energized_tiles.push(energized(0, col, 'down'))
      energized_tiles.push(energized(@puzzle.length - 1, col, 'up'))
      col += 1
    end

    row = 0
    while row < @puzzle.length
      energized_tiles.push(energized(row, 0, 'right'))
      energized_tiles.push(energized(row, @puzzle[0].length - 1, 'left'))
      row += 1
    end

    puts "The max was: #{energized_tiles.max}"
  end

  def energized(start, ending, direction)
    @visited = {}
    @tiles = {}
    @beans = [{start_row: start, start_col: ending, direction: direction}]

    while @beans.any?
      bean = @beans.delete_at(0)
      start_journey(bean[:start_row], bean[:start_col], bean[:direction])
    end

    @tiles.keys.size
  end

  def start_journey(row, col, direction)
    # I should stop if the tile is outside the grid
    return if row < 0 || row >= @puzzle.length
    return if col < 0 || col >= @puzzle[0].length

    key = "#{row},#{col}"
    @visited[key] ||= []

    # I should stop if I already visited that tile in that direction
    return if @visited[key].include?(direction)

    # register tile
    @visited[key].push(direction)
    @tiles[key] ||= {amount: 1, directions: []}
    @tiles[key][:amount] += 1 unless @tiles[key][:directions].include?(direction)

    # get the element
    char = @puzzle[row][col]

    case char
    when '.'
      # keep the same direction
      dir = DIRECTIONS[direction]
      start_journey(row + dir[:inc_row], col + dir[:inc_col], direction)
    when '/'
      # mirror upward
      next_direction = MIRRORS['upward'][direction]
      dir = DIRECTIONS[next_direction]
      start_journey(row + dir[:inc_row], col + dir[:inc_col], next_direction)
    when '\\'
      # mirror upward
      next_direction = MIRRORS['downward'][direction]
      dir = DIRECTIONS[next_direction]
      start_journey(row + dir[:inc_row], col + dir[:inc_col], next_direction)
    when '-'
      if %w[right left].include?(direction)
        # if the direction is right or left, do nothing
        dir = DIRECTIONS[direction]
        start_journey(row + dir[:inc_row], col + dir[:inc_col], direction)
      else
        # continue in 1
        dir = DIRECTIONS['right']
        start_journey(row + dir[:inc_row], col + dir[:inc_col], 'right')
        # save other bean
        dir = DIRECTIONS['left']
        @beans.push({start_row: row + dir[:inc_row], start_col: col + dir[:inc_col], direction: 'left'})
      end
    when '|'
      if %w[up down].include?(direction)
        # if the direction is down or up, do nothing
        dir = DIRECTIONS[direction]
        start_journey(row + dir[:inc_row], col + dir[:inc_col], direction)
      else
        # continue in 1
        dir = DIRECTIONS['up']
        start_journey(row + dir[:inc_row], col + dir[:inc_col], 'up')
        # save other bean
        dir = DIRECTIONS['down']
        @beans.push({start_row: row + dir[:inc_row], start_col: col + dir[:inc_col], direction: 'down'})
      end
    end
  end
end