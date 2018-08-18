require './GameBoard.rb'
require './GamePiece.rb'

module GameTools
	def create
		game = GameBoard.new
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

		return game
	end
end