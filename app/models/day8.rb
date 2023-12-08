class Day8
  include Spliteable
  attr_accessor :nodes, :directions, :start_nodes
  def initialize(directions, test = false)
    @puzzle = self.class.day_input(8, test)
    @directions = directions
    build_network
  end

  def self.go(directions, test = false)
    day = Day8.new(directions, test)
    day.start_journey
  end

  def self.go2(directions, test = false)
    day = Day8.new(directions, test)
    day.start_journey2
  end

  def build_network
    @nodes = {}
    @start_nodes = []
    @puzzle.each_with_index do |line, index|
      vals = line.split("=")
      node = vals[0].rstrip
      paths = vals[1].gsub('(','').gsub(')','').gsub(' ','').split(',')

      if node[2] == 'A'
        @start_nodes.push(node)
      end

      @nodes[node] = {left: paths[0], right: paths[1]}
    end
  end

  def start_journey
    steps = 0
    d = 0
    node = 'AAA'
    while node != 'ZZZ'
      node = @directions[d] == 'L' ?  @nodes[node][:left] : @nodes[node][:right]
      steps += 1
      d = d == @directions.length - 1 ? 0 : d + 1
    end
    puts "Steps needed: #{steps}"
  end
  def start_journey2
    steps = []

    @start_nodes.each do |node|
      s = 0
      d = 0
      traveled_node = node.dup
      while !traveled_node.ends_with?('Z')
        traveled_node = @directions[d] == 'L' ?  @nodes[traveled_node][:left] : @nodes[traveled_node][:right]
        puts "Traveling to #{traveled_node}"
        s += 1
        d = d == @directions.length - 1 ? 0 : d + 1
      end
      puts "Steps needed: #{s}"
      steps.push(s)
    end

    puts "Use LCM with: #{steps.join(' ')}"
  end
end