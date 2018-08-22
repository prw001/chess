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

	describe "#checkmate" do 

		context "when the King is in check" do 

			context "when the King cannot move anywhere else" do 
				game = GameBoard.new
				rook_sq_one = game.square_at([0, 7])
				rook_sq_two = game.square_at([1, 6])
				king_square = game.square_at([7, 7])
				rook_one = Rook.new(game, rook_sq_one, 'w')
				rook_sq_one.occupant = rook_one
				rook_two = Rook.new(game, rook_sq_two, 'w')
				rook_sq_two.occupant = rook_two
				king = King.new(game, king_square, 'b')
				king_square.occupant = king

				it "returns true" do 
					expect(dummy_class.checkmate(king, game)).to eql(true)
				end
			end

			context "when the King can move elsewhere out of check" do 
				game = GameBoard.new
				rook_sq_one = game.square_at([0, 7])
				rook_sq_two = game.square_at([1, 6])
				king_square = game.square_at([7, 6])
				rook_one = Rook.new(game, rook_sq_one, 'w')
				rook_sq_one.occupant = rook_one
				rook_two = Rook.new(game, rook_sq_two, 'w')
				rook_sq_two.occupant = rook_two
				king = King.new(game, king_square, 'b')
				king_square.occupant = king

				it "returns false" do 
					expect(dummy_class.checkmate(king, game)).to eql(false)
				end
			end
		end

		context "when the King is not in check" do 

			it "returns false" do 
				game = dummy_class.create
				king = game.square_at([0, 4]).occupant

				expect(dummy_class.checkmate(king, game)).to eql(false)
			end
		end
	end
end