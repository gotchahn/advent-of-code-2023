class Day15
  include Spliteable

  def initialize(test = false)
    @puzzle = self.class.day_input(15, test)[0].split(',')
  end

  def self.go(test = false)
    day = Day15.new(test)
    day.part1_result
    day.part2_result
  end

  def part1_result
    sum = 0
    @puzzle.each do |formula|
      sum += hash_of(formula)
    end
    puts "Sum: #{sum}"
  end

  def part2_result
    sum = 0
    boxes = {}

    @puzzle.each do |formula|
      if formula.index('=')
        data = formula.split('=')
        label = data[0]
        focus = data[1].to_i
        box_num = hash_of(label)
        key = "box#{box_num}"

        boxes[key] ||= {number: box_num + 1, lenses: []}
        pos = boxes[key][:lenses].find_index{|h| h[:label]== label}

        if pos
          boxes[key][:lenses][pos][:focus] = focus
        else
          boxes[key][:lenses].push({label: label, focus: focus})
        end
      else
        label = formula.split('-').first
        box_num = hash_of(label)
        key = "box#{box_num}"
        if boxes[key]
          pos = boxes[key][:lenses].find_index{|h| h[:label]== label}
          boxes[key][:lenses].delete_at(pos) if pos
        end
      end
    end

    boxes.values.each do |box|
      box[:lenses].each_with_index do |lense, index|
        sum += box[:number] * (index + 1) * lense[:focus]
      end
    end
    puts "Sum: #{sum}"
  end

  private
  def hash_of(label)
    label.chars.reduce(0){|val,num| ((val+num.ord)*17)%256}
  end

end