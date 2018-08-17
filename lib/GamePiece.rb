class GamePiece
	attr_reader :position
	attr_reader :is_taken
	attr_reader :color

	def initialize(position, color)
		@position = position
		@is_taken = false
		@color = color
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

class Pawn < GamePiece
	def initialize
		super
		@first_move = true
	end
end

class Rook < GamePiece
	def initialize
		super
		@first_move = true
	end
end

class Knight < GamePiece

end

class Bishop < GamePiece

end

class Queen < GamePiece

end

class King < GamePiece
	def initialize
		super
		@first_move = true
	end
end
