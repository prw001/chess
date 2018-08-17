class GameBoard
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

	def initialize
		@squares = create_rows
	end

	def square_at(coordinates)
		if coordinates[0] >= 0 && coordinates[1] >= 0
			return @squares[coordinates[0]][coordinates[1]]
		else
			return nil
		end
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