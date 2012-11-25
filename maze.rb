#!/usr/local/bin/ruby

# ########################################
# CMSC 330 - Project 1
# Name: Stewart Valencia
# ########################################

#-----------------------------------------------------------
# FUNCTION DECLARATIONS
#-----------------------------------------------------------

#Parse takes in a a standard maze file and converts it into
#Simple maze format
  def parse(file)
     line = file.gets
  if line == nil then return end
  #Invalid stores invalid line and valid stores valid lines
  invalid = Array.new
  valid = Array.new
  #i is used as a counter of invalid and j of valid
  i = 0
  j = 0
  
  #Makes sure it has these in the lines
  if (line !~ /^(maze:) / )&& (line !~ /(:){3}/) && (line !~ /(->)/)
    #Will do this everytime it's invalid
    puts "invalid maze"
    invalid[i] = line
    i += 1
  else
      # read 1st line, must be maze header
      m, sz, start, arrow, ends = line.split(/\s/,5)
      #Makes sure it matches numbers
      if (sz =~ /[^0-9]/) && (start =~ /[^0-9:]/) && (ends =~ /[^0-9:]/)
        puts "invalid maze"
        invalid[i] = line
        i+=1
        else
          start[":"] = " " 
          ends[":"] = " "
          #valid will only be used when there's no invalid lines
          if i == 0
            valid[j] ="#{sz} " + start + " " + ends
            j += 1
          end
          
      end
  end
  
  
  # read additional lines
  while line = file.gets do
    # begins with " and ends with ", must be path specification
    if line =~ /"/
      #Must only have letters, semicolon, and numbers
       if (line =~ / /) || (line !~ /[:A-Za-z0-9]/)  || (line !~ /"$/)
        if  i == 0
        puts "invalid maze"
        #Will only print this if it wasn't already is
      end
        invalid[i] = line
        i += 1
      else
        #Will try to split each paths with ",
        pathways = line.split(/\",/)
        #Will try  to parse each path
       pathways.each{ |paths|
        if (paths =~ /:{2}/) || (paths =~ /(,,)/) 
          if i == 0
          puts "invalid maze"
        end
        invalid[i] = line
        i += 1
        break        
        else
        half1, half2 = paths.split(/:/, 2)
        half2.chop!
        half2.chomp!("\"")
        if (half2 =~ /[:-]/) || (half2 =~ /"/)
          if i == 0
          puts "invalid maze"
        end
        invalid[i] = line
        i += 1
        break 
        end
        #Will delete stuff that isn't necessary
        paths.delete!(":")
        paths.gsub!(/[,(]/, " ")
        part1, part2 = paths.split(/[)]/)
        part1[0] = ""
        part1.gsub!("\\\"", "\"")
        part2.delete!("\"")
        part2.delete!(" ")
        if part2 =~ /[A-Za-ce-km-qstv-z]/
          if i == 0
          puts "invalid maze"
        end
        invalid[i] = line
        i += 1
        break 
        end
        if i == 0
        valid[j] = "path "+ part1 +" "+ part2
        j += 1
      end
      
    end
       }
     end
     
    # otherwise must be cell specification (since maze spec must be valid)
    else
      cell, directions, weights = line.split(/\s/,3)
      #Make sure it's in this format
      if (line !~ /^(\d+)+(,)+(\d+)+:+\s+([udlr]+|\s)+\s/) && (weights !~ /0-9.,/)
        if i == 0
        puts "invalid maze"
      end
        invalid[i] = line
         i += 1
        else
      #Clear these withfaces
       cell[","] = " "
       cell[":"] = " "
      if weights == nil
        weights = " "
        else
          weights = weights.gsub(/,/, " ")
          #sub commas for spaces
        end
      if i == 0
      valid[j] = cell + directions +" " +weights
      j += 1
      end
     end
    end
  end
  #Will print valid only if invalid is empty
  if i > 0
    puts invalid
    else
      puts valid
    end
  end

#-----------------------------------------------------------
# the following is a parser that reads in a simpler version
# of the maze files.  Use it to get started writing the rest
# of the assignment, if you like.  You can feel free to move
# or modify this function however you like in working on your
# assignment.

def read_and_print_simple_file(file)
  line = file.gets
  if line == nil then return end

  # read 1st line, must be maze header
  sz, sx, sy, ex, ey = line.split(/\s/)
  puts "header spec: size=#{sz}, start=(#{sx},#{sy}), end=(#{ex},#{ey})"

  # read additional lines
  while line = file.gets do

    # begins with "path", must be path specification
    if line[0...4] == "path"
       ws = w.split(/\s/)
       ws.each {|w| puts "  weight #{w}"}
       puts "path spec: #{name} starts at (#{x},#{y}) with dirs #{ds}"

    # otherwise must be cell specification (since maze spec must be valid)
    else
       x, y, ds, w = line.split(/\s/,4)
       puts "cell spec: coordinates (#{x},#{y}) with dirs #{ds}"
       ws = w.split(/\s/)
       ws.each {|w| puts "  weight #{w}"}
    end
  end
end

#The Maze class include cell and path classes
class Maze
  #Cell class represents each cell on the maze
  #Mode tells if it's start, end or neither
  #X and Y are its coordinates
  #Stores directions in a hash
  class Cell
    def initialize(x,y)
      @mode = "normal"
      @directions = Hash.new(nil)
      @x = x
      @y = y
    end
    def get_directions
      return @directions
    end
    def get_x
     return @x
    end
    def get_y
      return @y
    end
    def change_mode(string)
      @mode = string
    end
    def get_mode
      return @mode
    end
    def new_direction(name, weight)
      @directions[name] = weight.to_f
    end
    public :initialize
    public :change_mode
    public :new_direction
  end
  
  #Path class represents the paths of the maze file
  #X and Y represents the start
  class Path
    def initialize(name, x, y, directions)
        @name = name
        @x = x
        @y = y
        @directions = directions
    end
      public :initialize
    def get_x
      return @x
    end
    def get_y
      return @y
    end
    def get_directions
      return @directions
    end
    def get_name
      return @name
    end
  end
    
  #create maze will create a maze from the file
  def create_maze(file)
    line = file.gets
    if line == nil then return end

    # read 1st line, must be maze header
    sz, sx, sy, ex, ey = line.split(/\s/)
    #course is the maze course
    @course = Array.new(sz.to_i)
    @course.map!{Array.new(sz.to_i)}
    
    @course[sx.to_i][sy.to_i] = Cell.new(sx.to_i, sy.to_i)
    
    @start_x = sx.to_i
    @start_y = sy.to_i
    @course[sx.to_i][sy.to_i].change_mode("Start")
    
    @course[ex.to_i][ey.to_i] = Cell.new(ex.to_i, ey.to_i)
    @end_x = ex.to_i
    @end_y = ey.to_i
    @course[ex.to_i][ey.to_i].change_mode("End")
    
    @paths = Array.new
    # read additional lines
    while line = file.gets do

      # begins with "path", must be path specification
      if line[0...4] == "path"
        p, name, x, y, d = line.split(/\s/)
        ds = d.split(//)
        temp = Path.new(nil, nil, nil, nil)
        temp.initialize(name, x.to_i, y.to_i, ds)
        @paths.push(temp)
       
        # otherwise must be cell specification (since maze spec must be valid)
      else
        x, y, d, w = line.split(/\s/,4)
        if @course[x.to_i][y.to_i] == nil
          @course[x.to_i][y.to_i] = Cell.new(x.to_i,y.to_i)
        end
        
        ds = d.split(//)
        ws = w.split(/\s/)
        (0...ds.size).each { |i| 
          @course[x.to_i][y.to_i].new_direction(ds[i], ws[i])}
      end
    end
  end
  
  #These are just getter methods for the Maze class
  def path_arr()
    return @paths
  end
  
  def get_course
    return @course
  end
  
  def get_start
    return @course[@start_x][@start_y]
  end
  
  def get_x
    return @start_x
  end
  
  def get_y
    return @start_y
  end
  
  def get_end
    return @course[@end_x][@end_y]
  end
  
  
end
      
#Closed checks which rooms are closed      
def closed(file)
  line = file.gets
  rooms = 0
  if line == nil then return end
  size, sx, sy, ex, ey = line.split(/\s/)
  rooms = size.to_i*size.to_i
  while line = file.gets do
    if line[0...4] != "path"
    # checks for lines that do have these open walls
    if line =~ /[lurd]/
      rooms-= 1
    end
    end
    end
    
    puts rooms
    
  end

#Opens checks which rooms are open
def opens(file)
  line = file.gets
  ups = 0 
  downs = 0
  lefts = 0
  rights = 0
  if line == nil then return end
  while line = file.gets do
 if line[0...4] != "path"
    # check for each letter and adds it to letter count
    if line =~ /[u]/
      ups+= 1
    end
    if line =~ /[d]/
      downs+= 1
    end
    if line =~ /[l]/
      lefts+= 1
    end
    if line =~ /[r]/
      rights+= 1
    end
  end
  end
    puts "u: #{ups}, d: #{downs}, l: #{lefts}, r: #{rights}"    
  end  
  
#Rooms check which no-walls rooms are connected and the size of them
def room(file)
  line = file.gets
  rooms = 0
  if line == nil then return end
  sz, sx, sy, ex, ey = line.split(/\s/)
  size = sz.to_i
  #Course will represents cells
  #These cells will repsents if it's open or not
  course = Array.new(size)
  course.map!{Array.new(size, "No")}
  
  #find_open_rooms will be a recursive method that counts
  #each open room connected each other
  def find_open_rooms(x, y, course) 
    temp = 0
  if (course[x][y] != "Yes")
    return 0
  else 
    #Makes sure it marks as Counted
    course[x][y] = "Counted"
    temp+=1
    if x != 0
    temp += find_open_rooms(x-1, y, course)
    end
    if x != course.size-1
    temp += find_open_rooms(x+1, y, course)
    end
    if y != 0
    temp += find_open_rooms(x, y-1, course)
    end
    if y != course.size-1
    temp += find_open_rooms(x, y+1, course)
    end
    return temp
  end   
end
   
  while line = file.gets do
  #Only looks at cell specifications
  if line[0...4] != "path"
  x, y, directions, w = line.split(/\s/,4)
    # checks if all below is true
if (directions !~ /[A-Za-ce-km-qstv-z]/ && directions.size == 4)
  if (x.to_i != 0 && y.to_i != 0  && y.to_i != size-1 && x.to_i != size-1)
   if directions =~ /l/
      if directions =~ /u/
        if directions =~ /r/
          if directions =~ /d/
            course[x.to_i][y.to_i] = "Yes"
          end
        end
      end
    end
  end
  end
    end
  end
  #Will go through each room and counts near open cells
  (1...size-2).each{|x|
    (1...size-2).each{ |y|
    sum = find_open_rooms(x,y,course)
    if sum > rooms
      rooms = sum
    end
    }
    }
  puts rooms
end

#Will find paths that can be used and prints them out
#sorted in cost
def paths_list(file)
  maze = Maze.new
  maze.create_maze(file)
  pathways = Hash.new
  my_paths = maze.path_arr()
  my_course = maze.get_course
  if my_paths.size == 0
    puts "None" 
  end
  (0...my_paths.size).each {|i|
    sum = 0
    temp = my_paths[i]
    location_x = temp.get_x
    location_y = temp.get_y
    my_directions = temp.get_directions
    (0...my_directions.size).each{ |counter|
      move = my_directions[counter]
      current = my_course[location_x][location_y]
      the_weight = current.get_directions
      sum+= the_weight[move]
      if move =~ /[u]/
        location_y-= 1
      end
      if move =~ /[d]/
        location_y+= 1
      end
      if move =~ /[l]/
        location_x-= 1
      end
      if move =~ /[r]/
        location_x+= 1
      end
    }
  pathways[temp.get_name] = sum
  }
  sorted_list = pathways.sort {|a,b| a[1]<=>b[1]}
  (0...sorted_list.size).each{ |i|
    if i == sorted_list.size-1
      print sorted_list[i][0]
    else
      print sorted_list[i][0]+", "
    end
  }
end

#Will just pretty print out the simple maze
#It prints every three lines as they represents cells
#So it prints each row
def print_maze(file)
  maze = Maze.new
  maze.create_maze(file)
  my_course = maze.get_course
  total_length = (my_course.size*2)+2
  print_output = Array.new(total_length)
  
      (0...my_course.size).each{ |y|
        top = "+"    
        middle = "|"
        bottom = "+"
          (0...my_course.size).each{ |x|
          if my_course[x][y] != nil
          my_directions = my_course[x][y].get_directions
          else
            my_directions = Hash.new(nil)
          end
          
          if x != my_course.size-1 && my_course[x+1][y] != nil
          my_directions2 = my_course[x+1][y].get_directions
          else
            my_directions2 = Hash.new(nil)
          end
          if y != my_course.size-1 && my_course[x][y+1] != nil
          my_directions3 = my_course[x][y+1].get_directions
          else
            my_directions3 = Hash.new(nil)
        end
            
            if my_course[x][y] != nil
            case my_course[x][y].get_mode
              when "Start"
                middle += "s"
              when "End"
                middle += "e"
              else
                middle += " "
              end
              else
                middle += " "
              end
            
            if x != my_course.size-1 && !my_directions.empty? 
              if my_directions.has_key?("r")
                middle += " "
              else
                middle += "|"
              end
            else
              middle += "|"
            end
            
            if y != my_course.size-1 && !my_directions.empty?
              if my_directions.has_key?("d") 
                bottom+= " +"
              else
                bottom += "-+"
              end
            else
              bottom += "-+"
            end
            top += "-+"
          }
          if y == 0
          puts top
          end
          puts middle
          puts bottom
          }
        end

#solve will use breadth first search to see if a maze is solvable
def solve(file)
  maze = Maze.new
  maze.create_maze(file)
  my_course = maze.get_course
  solution = Array.new
  
  solution.push(maze.get_start)
  sol = 0
  while !solution.empty?
    temp = solution.pop
    if temp.get_mode == "End"
      sol = 1
    end
    
    if !temp.get_directions.empty? && temp.get_mode != "flag"
      temp.change_mode("flag")
      
      if temp.get_directions.has_key?("u") && temp.get_y != 0
        solution.push(my_course[temp.get_x][temp.get_y-1])
        end
      if temp.get_directions.has_key?("d") && temp.get_y != my_course.size-1
        solution.push(my_course[temp.get_x][temp.get_y+1])
        end
      if temp.get_directions.has_key?("l") && temp.get_x != 0
        solution.push(my_course[temp.get_x-1][temp.get_y])
        end
      if temp.get_directions.has_key?("r") && temp.get_x != my_course.size-1
        solution.push(my_course[temp.get_x+1][temp.get_y])    
      end
    end
  end
  
  if sol == 0
    puts "false"
    else
      puts "true"
  end
    
  end
  
#-----------------------------------------------------------
# EXECUTABLE CODE
#-----------------------------------------------------------

#----------------------------------
# check # of command line arguments

if ARGV.length < 2
  fail "usage: maze.rb <command> <filename>" 
end

command = ARGV[0]
file = ARGV[1]
maze_file = open(file)

#----------------------------------
# perform command

case command

  when "parse"
    parse(maze_file)

  #when "print"
    #read_and_print_simple_file(maze_file)
    
  when "closed"
    closed(maze_file)
    
  when "open"
    opens(maze_file)
    
  when "room"
    room(maze_file)
    
  when "paths"
    paths_list(maze_file)
    
  when "print"
    print_maze(maze_file)
    
  when "solve"
    solve(maze_file)

  else
    fail "Invalid command"
end
