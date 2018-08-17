module BoardBuilder

end

module PieceMoves

	def get_next_coordinates(origin, direction)
		next_coordinates = origin
		case direction
		when 'N'
			next_coordinates[1] -= 1
		when 'NE'
			next_coordinates[0] += 1
			next_coordinates[1] -= 1
		when 'E'
			next_coordinates[0] += 1
		when 'SE'
			next_coordinates[0] += 1
			next_coordinates[1] += 1
		when 'S'
			next_coordinates[1] += 1
		when 'SW'
			next_coordinates[0] -= 1
			next_coordinates[1] += 1
		when 'W'
			next_coordinates[0] -= 1
		when 'NW'
			next_coordinates[0] -= 1
			next_coordinates[1] -= 1
		else
			next_coordinates = nil
		end

		return next_coordinates
	end

	def get_pawn_moves(board, pawn)
		moveset = []
		origin = pawn.position.coordinates
		next_coordinates = origin

		pawn.color == 'w' ? directions = ['N', 'NE', 'NW'] : directions = ['S', 'SE', 'SW']
		pawn.first_move == true ? move_delta = 2 : move_delta = 1
		
		move_delta.times do #vertical moves
			next_coordinates = get_next_coordinates(next_coordinates, directions[0])
			next_square = board.square_at(next_coordinates)
			if next_square && !(next_square.occupant)
				moveset << next_square
			else
				break
			end
		end

		2.times do |index| #diagonal attacks
			next_square = board.square_at(get_next_coordinates(origin, directions[index + 1]))
			if next_square && next_square.occupant && next_square.occupant.color != pawn.color
				moveset << next_square
			end
		end

		return moveset
	end

	def get_rook_moves(board, rook)

	end

	def get_knight_moves(board, knight)

	end

	def get_bishop_moves(board, bishop)

	end

	def get_queen_moves(board, queen)

	end

	def get_king_moves(board, king)

	end

	def get_legal_moves(board, piece)
		case true
		when (piece.instance_of? Pawn)
			return get_pawn_moves(board, piece)
		when (piece.instance_of? Rook)
			return get_rook_moves(board, piece)
		when (piece.instance_of? Knight)
			return get_knight_moves(board, piece)
		when (piece.instance_of? Bishop)
			return get_bishop_moves(board, piece)
		when (piece.instance_of? Queen)
			return get_queen_moves(board, piece)
		else
			return get_king_moves(board, piece)
		end
	end
end