require 'GameTools.rb'
require 'GamePiece.rb'
require 'GameBoard.rb'

describe 'PieceMoves' do 

	let(:dummy_class) {Class.new {extend PieceMoves} }
	let(:tools_class) {Class.new {extend GameTools} }

	describe '#get_next_coordinates' do 

		context 'when direction is N' do 

			it 'decrements the row value' do

				expect(dummy_class.get_next_coordinates([7, 7], 'N')).to eql([6, 7])
			end
		end

		context 'when direction is NE' do 

			it 'increments the column value and decrements the row value' do 

				expect(dummy_class.get_next_coordinates([7, 7], 'NE')).to eql([6, 8])
			end
		end

		context 'when direction is E' do 

			it 'increments the column value' do 

				expect(dummy_class.get_next_coordinates([7, 7], 'E')).to eql([7, 8])
			end
		end

		context 'when direction is SE' do 

			it 'increments the column and row values' do 

				expect(dummy_class.get_next_coordinates([7, 7], 'SE')).to eql([8, 8])
			end
		end

		context 'when direction is S' do 

			it 'increments the row value' do 

				expect(dummy_class.get_next_coordinates([7, 7], 'S')).to eql([8, 7])
			end
		end

		context 'when direction is SW' do 

			it 'decrements the column value and increments the row value' do 

				expect(dummy_class.get_next_coordinates([7, 7], 'SW')).to eql([8, 6])
			end
		end

		context 'when direction is W' do 

			it 'decrements the column value' do 

				expect(dummy_class.get_next_coordinates([7, 7], 'W')).to eql([7, 6])
			end
		end

		context 'when direction is NW' do 

			it 'decrements the column and row values' do 
				
				expect(dummy_class.get_next_coordinates([7, 7], 'NW')).to eql([6, 6])
			end
		end

		context 'when no direction given' do 

			it 'returns nil' do 

				expect(dummy_class.get_next_coordinates([7, 7], nil)).to eql(nil)
			end
		end
	end

	describe "#combine_coordinates" do 

		it 'returns the sum of each ordinate' do 

			expect(dummy_class.combine_coordinates([1, 2], [3, 4])).to eql([4, 6])
		end
	end

	describe "#is_in_check" do 

		context "when the King is in check" do 

			it "returns true" do 
				game = tools_class.create
				test_square = game.square_at([5, 2])
				king_one = King.new(game, test_square, 'b')

				expect(king_one.is_in_check(king_one.color, game, king_one.position)).to eql(true)
			end
		end

		context "when the King is not in check" do 

			it "returns false" do 
				game = tools_class.create
				king_two = game.square_at([0, 4]).occupant

				expect(king_two.is_in_check(king_two.color, game, king_two.position)).to eql(false)
			end
		end
	end

	describe "#checkmate?" do 

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
				game = tools_class.create
				king = game.square_at([0, 4]).occupant

				expect(dummy_class.checkmate(king, game)).to eql(false)
			end
		end
	end
end




