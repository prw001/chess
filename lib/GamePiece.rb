class GamePiece
	attr_reader :position
	attr_reader :is_taken

	def initialize(position)
		@position = position
		@is_taken = false
	end

	def gets_taken
		@position = nil
		@is_taken = true
	end

	def take_piece(piece)
		piece.gets_taken
	end

	def move(to_square)
		if to_square.occupant
			take_piece(to_square.occupant)
		end
		@position.occupant = nil
		@position = to_square
		to_square.occupant = self
	end
end