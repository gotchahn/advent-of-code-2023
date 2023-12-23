class CustomPolygon
  attr_accessor :vertices

  def initialize
    @vertices = []
  end

  def add_vertex(x, y)
    @vertices.push([x, y])
  end

  def inside?(test_point)
    vs = @vertices + [@vertices.first]
    xi, yi = @vertices.reduce([0,0]) { |(sx,sy),(x,y)| [sx+x, sy+y] }.map { |e|
      e.to_f/@vertices.size } # interior point
    x, y = test_point
    vs.each_cons(2).all? do |(x0,y0),(x1,y1)|
      if x0 == x1 # vertical edge
        (xi > x0) ? (x >= x0) : (x <= x0)
      else
        k, slope = line_equation(x0,y0,x1,y1)
        (k + xi*slope > yi) ? (k + x*slope >= y) : (k + x*slope <= y)
      end
    end
  end

  def line_equation(x0,y0,x1,y1)
    s = (y1-y0).to_f/(x1-x0)
    [y0-s*x0, s]
  end
end