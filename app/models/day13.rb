class Day13
  attr_accessor :patterns, :puzzle

  def initialize(test = false)
    filename = "./public/day13#{test ? '_test' : ''}.txt"
    @puzzle = File.read(filename).split("\n\n")
    build_patterns
  end

  def self.go(test = false)
    day = Day13.new(test)
    day.reflections
  end

  def build_patterns
    @patterns = []
    @puzzle.each do |map|
      @patterns.push(map.split("\n"))
    end
    @patterns
  end

  def reflections
    rows = 0
    cols = 0
    @patterns.each_with_index do |pattern, index|
      puts "\nLet's check Pattern #{index}\n===================="
      #rows
      for i in 0..(pattern.length - 2) do
        if pattern[i] == pattern[i+1]
          puts "Row #{i} == #{i+1}"
          equal = true
          p2 = i - 1
          for p in (i+2)..(pattern.length - 1)
            puts "Re-check rows #{p} == #{p2}"
            break if p2 < 0
            if pattern[p] != pattern[p2]
              equal = false
              break
            end
            p2 -= 1
          end

          if equal
            puts "Adding #{i}<>#{i+1}"
            rows += (i+1) * 100
          end
        end
      end

      # cols
      for i in 0..(pattern[0].length - 2) do
        equal = true
        pattern.each do |row|
          if row[i] != row[i+1]
            equal = false
            break
          end
        end
        if equal
          puts "Col #{i} == #{i+1}"
          equalCol = true
          p2 = i - 1
          for p in (i+2)..(pattern[0].length - 1)
            break if p2 < 0
            puts "Re-check cols #{p} == #{p2}"
            if string_from_col(pattern, p) != string_from_col(pattern, p2)
              equalCol = false
              break
            end
            p2 -= 1
          end

          if equalCol
            cols += i + 1
            puts "Adding Col #{i} <> #{i+1}"
          end
        end
      end
    end
    sum = rows + cols
    puts "The Sum: #{sum}"
  end

  def string_from_col(pattern, col)
    c=""
    pattern.each do |row|
      c += row[col]
    end
    c
  end
end