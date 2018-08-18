require 'GameTools.rb'
require 'GamePiece.rb'
require 'GameBoard.rb'

describe 'PieceMoves' do 

	let(:dummy_class) {Class.new {extend PieceMoves} }

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

	describe '#get_pawn_moves' do 

		context "when pawn's first move and pawn is not blocked" do 
			game = GameBoard.new
			origin = game.square_at([1, 1])
			unblocked_pawn = Pawn.new(origin, 'b')
			origin.occupant = unblocked_pawn
			it "returns an array of two moves" do 
				moves = dummy_class.get_pawn_moves(game, unblocked_pawn)
				expect(moves.length).to eql(2)
				expect(moves[0].coordinates).to eql([2, 1])
				expect(moves[1].coordinates).to eql([3, 1])
			end
		end

		context "when pawn's first move and pawn is blocked" do 
			game = GameBoard.new
			second_square = game.square_at([1, 2])
			blocked_pawn = Pawn.new(second_square, 'b')
			second_square.occupant = blocked_pawn

			adjacent_square = game.square_at([2, 2])
			blocker = Pawn.new(adjacent_square, 'w')
			adjacent_square.occupant = blocker

			it "returns an empty array" do 
				moves = dummy_class.get_pawn_moves(game, blocked_pawn)
				expect(moves).to eql([])
			end
		end

		context "when pawn's first move, not blocked, with attackers" do 
			game = GameBoard.new
			origin = game.square_at([1, 1])
			active_pawn = Pawn.new(origin, 'b')
			origin.occupant = active_pawn

			sw_square = game.square_at([2, 0])
			attacker_one = Pawn.new(sw_square, 'w')
			sw_square.occupant = attacker_one

			se_square = game.square_at([2, 2])
			attacker_two = Pawn.new(se_square, 'w')
			se_square.occupant = attacker_two

			it "returns an array of length four" do 
				moves = dummy_class.get_pawn_moves(game, active_pawn)
				expect(moves.length).to eql(4)
			end

			it "includes diagonal move option(s)" do 
				moves = dummy_class.get_pawn_moves(game, active_pawn)
				expect(moves[2]).to eql(se_square)
				expect(moves[3]).to eql(sw_square)
			end
		end

		context "first move, pawn is not blocked, one attacker and one ally diagonal to it" do 
			game = GameBoard.new
			origin = game.square_at([1, 1])
			active_pawn = Pawn.new(origin, 'b')
			origin.occupant = active_pawn

			sw_square = game.square_at([2, 0])
			attacker_one = Pawn.new(sw_square, 'w')
			sw_square.occupant = attacker_one

			se_square = game.square_at([2, 2])
			ally_one = Pawn.new(se_square, 'b')
			se_square.occupant = ally_one

			it "returns an array of length three" do 
				moves = dummy_class.get_pawn_moves(game, active_pawn)
				expect(moves.length).to eql(3)
			end

			it "includes diagonal options, but not when occupied by an ally" do 
				moves = dummy_class.get_pawn_moves(game, active_pawn)
				expect(moves[2]).to eql(sw_square)
				expect(moves[3]).to eql(nil)
			end
		end
	end
end




