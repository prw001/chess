require './GameBoard.rb'
require './GamePiece.rb'
require './PieceMoves.rb'
module GameTools
	include PieceMoves
	def deep_copy(rows)
		rows_copy = []
		rows.each do |row|
			rows_copy << row.dup
		end
		return rows_copy
	end

	def abs(value)
		case 
		when value == 0
			return 0
		when value < 0
			return value * -1
		else
			return value
		end
	end

	def assemble(game)
		black_pieces = [
			Rook.new(game, game.square_at([0, 0]), 'b'),
			Knight.new(game, game.square_at([0, 1]), 'b'),
			Bishop.new(game, game.square_at([0, 2]), 'b'),
			Queen.new(game, game.square_at([0, 3]), 'b'),
			King.new(game, game.square_at([0, 4]), 'b'),
			Bishop.new(game, game.square_at([0, 5]), 'b'),
			Knight.new(game, game.square_at([0, 6]), 'b'),
			Rook.new(game, game.square_at([0, 7]), 'b'),
		]

		8.times do |index|
			black_pieces << Pawn.new(game, game.square_at([1, index]), 'b')
		end

		black_pieces.each do |piece|
			piece.position.occupant = piece
		end

		white_pieces = [
			Rook.new(game, game.square_at([7, 0]), 'w'),
			Knight.new(game, game.square_at([7, 1]), 'w'),
			Bishop.new(game, game.square_at([7, 2]), 'w'),
			Queen.new(game, game.square_at([7, 3]), 'w'),
			King.new(game, game.square_at([7, 4]), 'w'),
			Bishop.new(game, game.square_at([7, 5]), 'w'),
			Knight.new(game, game.square_at([7, 6]), 'w'),
			Rook.new(game, game.square_at([7, 7]), 'w'),
		]

		8.times do |index|
			white_pieces << Pawn.new(game, game.square_at([6, index]), 'w')
		end

		white_pieces.each do |piece|
			piece.position.occupant = piece
		end

		game.white_pieces = white_pieces
		game.black_pieces = black_pieces
		return game
	end

	def puts_king_in_check(game, active_piece, destination)
		mock_game = game.dup
		mock_coords = active_piece.position.coordinates.dup
		mock_piece = mock_game.square_at(mock_coords).occupant
		mock_to = destination.coordinates.dup
		mock_square = mock_game.square_at(mock_to)
		mock_piece.move(mock_square)

		if active_piece.color == 'w'
			return is_in_check('w', mock_game, mock_game.white_pieces[4].position)
		else
			return is_in_check('b', mock_game, mock_game.black_pieces[4].position)
		end
	end

	def get_attacking_path(attacker, king, game)
		path = [attacker.position]
		origin = attacker.position.coordinates.dup
		coord_diff = difference_of_coordinates(attacker.position.coordinates, king.position.coordinates)

		if coord_diff[0] == 0
			diff = coord_diff[1]
			delta = [0, (diff / abs(diff))]
		elsif coord_diff[1] == 0
			diff = coord_diff[0]
			delta = [(diff / abs(diff)), 0]
		else
			diff = coord_diff[0]
			delta = [(diff / abs(diff)), (diff / abs(diff))]
		end

		(diff - 1).times do 
			origin = combine_coordinates(origin, delta)
			path << game.square_at(origin)
		end
		return path
	end

	def can_be_blocked(king, game)
		attacking_pieces = []
		if king.color == 'w'
			opposite_piece_set = game.black_pieces
			ally_piece_set = game.white_pieces
		else
			opposite_piece_set = game.white_pieces
			ally_piece_set = game.black_pieces
		end

		opposite_piece_set.each do |piece|
			if (piece.get_valid_moves.include? king.position)
				attacking_pieces << piece
			end
		end
		if attacking_pieces.length > 1
			return false
		end
		if attacking_pieces.length == 1
			unless (attacking_pieces[0].instance_of? Knight)
				attacking_path = get_attacking_path(attacking_pieces[0], king, game)
			else
				attacking_path << attacking_pieces[0].position
			end
			ally_piece_set.each do |piece|
				moves = piece.get_valid_moves
				moves.each do |move|
					if (attacking_path.include? move)
						return true
					end
				end
			end
		end
		return false
	end

	def checkmate(king, game)
		if is_in_check(king.color, game, king.position) && 
			(king.get_valid_moves == []) && !(can_be_blocked(king, game))
				game.game_over = true
				return true
		else
			return false
		end
	end
end