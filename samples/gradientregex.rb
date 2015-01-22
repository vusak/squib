
def parse_color(str)
  stops = /   # used to capture the stops
    \s*         # leading whitespace is ok
    ([\w]+)     # color
    @           # no spaces here
    (\d+\.?\d*) # offset number
  /x
  linear_gradient = /
    \(          # coordinate 1
      (\d+\.?\d*) # x1 number
      ,\s*        # whitespace after comma is ok
      (\d+\.?\d*) # y1 number
    \)
    \s*         # space between coordinates is ok
    \(          # coordinate 2
      (\d+\.?\d*) # x2 number
      ,\s*        # whitespace after comma is ok
      (\d+\.?\d*) # y2 number
    \)
    (#{stops})+ # stops
    \s*         # trailing whitespace is ok
  /x
  radial_gradient = /
    \(          # coordinate 1
      (\d+\.?\d*) # x1 number
      ,\s*        # whitespace after comma is ok
      (\d+\.?\d*) # y1 number
      ,\s*        # whitespace after comma is ok
      (\d+\.?\d*) # r1 number
    \)
    \s*         # space between coordinates is ok
    \(          # coordinate 2
      (\d+\.?\d*) # x2 number
      ,\s*        # whitespace after comma is ok
      (\d+\.?\d*) # y2 number
      ,\s*        # whitespace after comma is ok
      (\d+\.?\d*) # r1 number
    \)
    (#{stops})+ # stops
    \s*         # trailing whitespace is ok
  /x

  if match = str.match(linear_gradient)
    x1,y1,x2,y2 = match.captures
    stops = str.scan(stops)
    puts "Coords: x1: #{x1}, y1: #{y1}, x2: #{x2}, #{y2}"
    puts "Stops: #{stops}"
  elsif match = str.match(radial_gradient)
    x1,y1,r1,x2,y2,r2 = match.captures
    stops = str.scan(stops)
    puts "Coords: coord1: #{x1}, #{y1},#{r1} | coord2: #{x2}, #{y2},#{r2}"
    puts "Stops: #{stops}"
  else
    puts "No match"
  end
end

parse_color("(1.0, 2.0) (3.0, 4.0) blue@0.5 red@1.0")
parse_color("(1.0,2.0)(3.0,4.0)green@0.5yellow@1.0")
parse_color("(1.0, 2.0, 5.0)(3.0, 4.0, 6.0) green@0.5 yellow@1.0 ")