module PieceMoves

	def get_next_coordinates(origin, direction)
		next_coordinates = origin.dup
		case direction
		when 'N'
			next_coordinates[0] -= 1
		when 'NE'
			next_coordinates[1] += 1
			next_coordinates[0] -= 1
		when 'E'
			next_coordinates[1] += 1
		when 'SE'
			next_coordinates[1] += 1
			next_coordinates[0] += 1
		when 'S'
			next_coordinates[0] += 1
		when 'SW'
			next_coordinates[1] -= 1
			next_coordinates[0] += 1
		when 'W'
			next_coordinates[1] -= 1
		when 'NW'
			next_coordinates[1] -= 1
			next_coordinates[0] -= 1
		else
			next_coordinates = nil
		end

		return next_coordinates
	end

	def difference_of_coordinates(set_one, set_two)
		return [(set_one[0] - set_two[0]), (set_one[1] - set_two[1])]
	end

	def combine_coordinates(set_one, set_two)
		return [(set_one[0] + set_two[0]), (set_one[1] + set_two[1])]
	end

	def pawn_is_blocking(kings_color, game, square)
		origin = square.coordinates.dup
		if kings_color == 'w'
			coord_shifts = [[-1, -1], [-1, 1]]
		else
			coord_shifts = [[1, -1], [1, 1]]
		end
		diagonals = [game.square_at(combine_coordinates(origin, coord_shifts[0])),
	 				game.square_at(combine_coordinates(origin, coord_shifts[1]))]
	 	diagonals.each do |diagonal|
	 		if diagonal && (diagonal.occupant.instance_of? Pawn) && 
	 		   diagonal.occupant.color != kings_color
	 		   		return true
	 		end
	 	end
	 	return false
	end

	def castle_rook(game, king_dest, king)
		king.color == 'w' ? row = 7 : row = 0
		king_dest[1] == 2 ? column = 0 : column = 7
		king_dest[1] == 2 ? castle_column = 3 : castle_column = 5
		castle_square = game.square_at([row, castle_column])
		puts castle_square
		rook = game.square_at([row, column]).occupant
		puts rook
		rook.move(castle_square)
		puts rook.position.coordinates
	end

	def path_clear?(king, rook, game)
		distance = difference_of_coordinates(rook.position.coordinates, king.position.coordinates)[1]
		delta = [0, (distance / abs(distance))]
		current_coords = king.position.coordinates.dup
		(abs(distance) - 1).times do 
			current_coords = combine_coordinates(current_coords, delta)
			if game.square_at(current_coords).occupant || is_in_check(king.color, game, game.square_at(current_coords))
				return false
			end
		end
		return true
	end

	def get_castle_squares(king, game)
		rooks = []
		squares = []
		unless king.first_move == false
			if king.color == 'w'
				castle_coords_west = [7, 2]
				castle_coords_east = [7, 6]
				game.white_pieces.each do |piece|
					if (piece.instance_of? Rook) && 
					   (piece.position.coordinates == [7, 0] ||
					   	piece.position.coordinates == [7, 7]) &&
					   	piece.first_move == true
					   		rooks << piece
					end
				end
			else
				castle_coords_west = [0, 2]
				castle_coords_east = [0, 6]
				game.black_pieces.each do |piece|
					if (piece.instance_of? Rook) && 
					   (piece.position.coordinates == [0, 0] ||
					   	piece.position.coordinates == [0, 7]) &&
					   	piece.first_move == true
					   		rooks << piece
					end
				end
			end
		end
		if rooks.length > 0
			rooks.each do |rook|
				if path_clear?(king, rook, game)
					if rook.position.coordinates[1] == 0
						squares << game.square_at(castle_coords_west)
					else
						squares << game.square_at(castle_coords_east)
					end
				end
			end
		end
		return squares
	end

	def is_in_check(kings_color, game, position)
		game.rows.each do |row|
			row.each do |square|
				if square.occupant && square.occupant.color != kings_color &&
					!(square.occupant.instance_of? King) && !(square.occupant.instance_of? Pawn)
						moveset = square.occupant.get_valid_moves
					if moveset.include? position
						return true
					end
				end
				if pawn_is_blocking(kings_color, game, position)
					return true
				end
			end
		end
		return false
	end
end