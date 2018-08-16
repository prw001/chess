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
		squares = create_rows
	end

	def square_at(coordinates)
		return squares[coordinates[0]][coordinates[1]]
	end

end

class ChessSquare
	attr_reader :coordinates
	attr_accessor :is_occupied

	def initialize(coordinates)
		@coordinates = coordinates
		@is_occupied = false
	end
end