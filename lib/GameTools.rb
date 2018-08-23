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

	def checkmate(king, game)
		if is_in_check(king.color, game, king.position) && 
			(king.get_valid_moves == [])
				game.game_over = true
				return true
		else
			return false
		end
	end
end