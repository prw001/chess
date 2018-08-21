class GameBoard
	attr_reader :rows
	attr_accessor :black_pieces
	attr_accessor :white_pieces
	def create_rows
		rows = []
		8.times do |row_index| 
			rows[row_index] = []
			8.times do |column_index|
				rows[row_index][column_index] = ChessSquare.new([row_index, column_index])
			end
		end
		return rows
	end

	def initialize(black_pieces = nil, white_pieces = nil, rows = nil)
		unless rows
			@rows = create_rows
		else
			@rows = rows
		end
		@black_pieces = black_pieces
		@white_pieces = white_pieces
	end

	def square_at(coordinates)
		if (coordinates[0] >= 0 && coordinates[0] < 8) &&
		   (coordinates[1] >= 0 && coordinates[1] < 8)
			return @rows[coordinates[0]][coordinates[1]]
		else
			return nil
		end
	end

	def display
		row = 7
		column = 0
		top = "┏━━━━━━━━━━━━━━━━━┓\n"
		bottom = "┗━━━━━━━━━━━━━━━━━┛\n" + "+ 1 2 3 4 5 6 7 8 +\n"
		rows = ""
		while row >= 0
			rows << "┃ "
			while column < 8
				if square_at([row, column]).occupant
					symbol = square_at([row, column]).occupant.symbol
				elsif (row % 2 == 0 && column % 2 == 0) || 
					  (row % 2 == 1 && column % 2 == 1)
					    symbol = '⬛'
				else
					symbol = '⬜'
				end
				rows << symbol + " "
				column += 1
			end
			rows << "┃\n"
			row -= 1
			column = 0
		end
		board = top + rows + bottom
		puts board
	end
end

class ChessSquare
	attr_reader :coordinates
	attr_accessor :occupant
	def initialize(coordinates, occupant = nil)
		@coordinates = coordinates
		@occupant = occupant
	end
end