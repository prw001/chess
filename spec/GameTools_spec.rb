require 'GameTools.rb'

describe "GameTools" do 

	let(:dummy_class) {Class.new {extend GameTools} }

	describe '#deep_copy' do 
		context 'when given an array' do 
			it 'copies that array, but not its location in memory' do 
				a = [[1, 2], [3]]
				b = dummy_class.deep_copy(a)
				
				expect(a.equal? b).to eql(false)
				expect(a == b).to eql(true)
			end
		end
	end

	describe '#puts_king_in_check' do 
		context 'when a player puts their own king in check' do 
			it 'returns true' do 
				game = GameBoard.new
				king_square = game.square_at([7, 0])
				pawn_square = game.square_at([6, 1])
				bishop_square = game.square_at([5, 2])
				destination = game.square_at([5, 1])
				king = King.new(game, king_square, 'w')
				king_square.occupant = king 
				pawn = Pawn.new(game, pawn_square, 'w')
				pawn_square.occupant = pawn
				bishop = Bishop.new(game, bishop_square, 'b')
				bishop_square.occupant = bishop
				game.white_pieces = ['-', '-', '-', '-', king]

				expect(dummy_class.puts_king_in_check(game, pawn, destination)).to eql(true)
			end
		end

		context 'when a player does not put their own king in check' do 
			it 'returns false' do 
				game = GameBoard.new
				king_square = game.square_at([7, 0])
				pawn_square = game.square_at([6, 1])
				bishop_square = game.square_at([5, 3])
				destination = game.square_at([5, 1])
				king = King.new(game, king_square, 'w')
				king_square.occupant = king 
				pawn = Pawn.new(game, pawn_square, 'w')
				pawn_square.occupant = pawn
				bishop = Bishop.new(game, bishop_square, 'b')
				bishop_square.occupant = bishop
				game.white_pieces = ['-', '-', '-', '-', king]

				expect(dummy_class.puts_king_in_check(game, pawn, destination)).to eql(false)
			end
		end
	end
end