This code sample came from a 2010 school project.

The Maze Solver is a Ruby program that processes text files containing maze data, and will analyze 
that data to determine certain features of each maze. 

The purpose of the project is to show that I am familiar with Ruby's built-in data structures 
and text processing capabilities.

Maze Solver Format and Commands
	Maze header -  <size> <start_x> <start_y> <end_x> <end_y>
		These fields indicate (respectively) the size of the maze and the (x,y) coordinates for the start 
		and end points. Coordinates start in the upper left-hand corner of the maze and increase as they 
		move down and right. All mazes are square.
	Lines representing cells take the form - <x> <y> <dirs> <weights>
		The dirs part is a set of up to four "open wall" characters, (any combination of 'udlr', representing
		up, down, left, right), followed by up to four floating point weights (separated by spaces), 
		one per character in dirs.
	Paths - path <path_name> <start x> <start y> <move 1><move 2>...
		Each path consists of a name, a starting x/y coordinate, and a list of directions, all concatenated 
		together, that the path takes to reach its destination. The start coordinates must consist only of 
		integers, and directions may only include the letters "u," "d," "l," and "r,".
	Closed - % ruby maze.rb closed <maze_name>
		Counts number of closed cells in maze.
	Open - % ruby maze.rb open <maze_name>
		Counts number of open cells in maze, sorted by direction.
	Room - % ruby maze.rb room <maze_name>
		Counts maximum room size.
	Rank - % ruby maze.rb paths <maze_name>
		Ranks weighthed maze paths by costs.
	Print - % ruby maze.rb print <maze_name>
		Pretty print the maze.
	Solve - % ruby maze.rb solve <maze_name>
		Finds out if maze has a solution, returning true or false. Uses breath-first search.
	Parse - % ruby maze.rb parse <maze_name>
		Parses standard maze files using Ruby regular expressions, and output the maze in simple maze
		format.

Files:
	maze.rb - Maze solver
	goTest.rb - script to run maze test case
	inputs - maze test cases
	outputs - Expected output of maze test cases
		
-Stewart Valencia