require 'GamePiece.rb'
require 'GameBoard.rb'
require 'PieceMoves.rb'
describe "GamePiece" do 

	describe "#take_piece" do 

		context "when one piece attacks another" do 
			defending_piece = GamePiece.new(nil, [0, 0], 'b')
			attacking_piece = GamePiece.new(nil, [1, 1], 'w')

			it "removes the defending piece's position" do 
				attacking_piece.take_piece(defending_piece)
				expect(defending_piece.position).to eql(nil)
			end

			it "changes the defender's 'is_taken' attribute" do 
				expect(defending_piece.is_taken).to eql(true)
			end
		end
	end

	describe "#get_valid_moves" do 

		context "when Queen is not blocked in any direction" do 

			context "when Queen is at board's center" do 

				it "returns a moveset of length 27" do 
					game = GameBoard.new
					origin = game.square_at([3, 3])
					queen = Queen.new(game, origin, 'w')
					origin.occupant = queen

					expect(queen.get_valid_moves.length).to eql(27)
				end

				it "contains square objects" do 
					game = GameBoard.new
					origin = game.square_at([3, 3])
					queen = Queen.new(game, origin, 'w')
					origin.occupant = queen
					expect(queen.get_valid_moves[0]).to be_an_instance_of(ChessSquare)
				end
			end

			context "when Queen is in corner" do 

				it "returns a moveset of length 21" do 
					game = GameBoard.new
					origin = game.square_at([0, 0])
					queen = Queen.new(game, origin, 'w')
					origin.occupant = queen

					expect(queen.get_valid_moves.length).to eql(21)
				end
			end
		end

		context "when Queen is blocked from all directions" do 

			it "returns a moveset of length 8" do 
				game = GameBoard.new
				origin = game.square_at([4, 4])
				queen = Queen.new(game, origin, 'w')
				origin.occupant = queen

				sq_one = game.square_at([3, 4])
				pawn_one = Pawn.new(game, sq_one, 'b')
				sq_one.occupant = pawn_one

				sq_two = game.square_at([3, 5])
				pawn_two = Pawn.new(game, sq_two, 'b')
				sq_two.occupant = pawn_two

				sq_three = game.square_at([4, 5])
				pawn_three = Pawn.new(game, sq_two, 'b')
				sq_three.occupant = pawn_three

				sq_four = game.square_at([5, 5])
				pawn_four = Pawn.new(game, sq_two, 'b')
				sq_four.occupant = pawn_four

				sq_five = game.square_at([5, 4])
				pawn_five = Pawn.new(game, sq_two, 'b')
				sq_five.occupant = pawn_five

				sq_six = game.square_at([5, 3])
				pawn_six = Pawn.new(game, sq_two, 'b')
				sq_six.occupant = pawn_six

				sq_seven = game.square_at([4, 3])
				pawn_seven = Pawn.new(game, sq_two, 'b')
				sq_seven.occupant = pawn_seven

				sq_eight = game.square_at([3, 3])
				pawn_eight = Pawn.new(game, sq_two, 'b')
				sq_eight.occupant = pawn_eight

				expect(queen.get_valid_moves.length).to eql(8)
			end
		end

		context "when rook is not blocked in any direction" do 

			context "when rook is in center of board" do 

				it "returns a moveset of length 14" do 
					game = GameBoard.new
					origin = game.square_at([4, 4])
					rook = Rook.new(game, origin, 'w')
					origin.occupant = rook

					expect(rook.get_valid_moves.length).to eql(14)
				end
			end
		end

		context "when bishop is not blocked in any direction" do 

			context "when bishop is in center of board" do 

				it "returns a moveset of length 13" do 
					game = GameBoard.new
					origin = game.square_at([4, 4])
					bishop = Bishop.new(game, origin, 'w')
					origin.occupant = bishop

					expect(bishop.get_valid_moves.length).to eql(13)
				end
			end
		end
	end

	describe "#move" do 

		context "when a piece is moved" do 
			from_square = ChessSquare.new([0, 0])
			to_square = ChessSquare.new([1, 1])
			active_piece = GamePiece.new(nil, from_square, 'w')
			from_square.occupant = active_piece

			it "updates its position" do 
				active_piece.move(to_square)

				expect(active_piece.position).to eql(to_square)
			end

			it "no longer occupies the previous square" do 
				expect(from_square.occupant).to eql(nil)
			end

			it "takes any piece occupying that square" do 
				active_piece.move(from_square)
				passive_piece = GamePiece.new(nil, to_square, 'b')
				to_square.occupant = passive_piece
				active_piece.move(to_square)

				expect(active_piece.position).to eql(to_square)
				expect(passive_piece.position).to eql(nil)
				expect(passive_piece.is_taken).to eql(true)
			end
		end
	end
end

describe "Pawn" do

	describe '#get_valid_moves' do 

		context "when pawn's first move and pawn is not blocked" do 
			game = GameBoard.new
			origin = game.square_at([1, 1])
			unblocked_pawn = Pawn.new(game, origin, 'b')
			origin.occupant = unblocked_pawn

			it "returns an array of two moves" do 
				moves = unblocked_pawn.get_valid_moves

				expect(moves.length).to eql(2)
				expect(moves[0].coordinates).to eql([2, 1])
				expect(moves[1].coordinates).to eql([3, 1])
			end
		end

		context "when pawn's first move and pawn is blocked" do 
			game = GameBoard.new
			second_square = game.square_at([1, 2])
			blocked_pawn = Pawn.new(game, second_square, 'b')
			second_square.occupant = blocked_pawn

			adjacent_square = game.square_at([2, 2])
			blocker = Pawn.new(game, adjacent_square, 'w')
			adjacent_square.occupant = blocker

			it "returns an empty array" do 
				moves = blocked_pawn.get_valid_moves

				expect(moves).to eql([])
			end
		end

		context "when pawn's first move, not blocked, with attackers" do 
			game = GameBoard.new
			origin = game.square_at([1, 1])
			active_pawn = Pawn.new(game, origin, 'b')
			origin.occupant = active_pawn

			sw_square = game.square_at([2, 0])
			attacker_one = Pawn.new(game, sw_square, 'w')
			sw_square.occupant = attacker_one

			se_square = game.square_at([2, 2])
			attacker_two = Pawn.new(game, se_square, 'w')
			se_square.occupant = attacker_two

			it "returns an array of length four" do 
				moves = active_pawn.get_valid_moves

				expect(moves.length).to eql(4)
			end

			it "includes diagonal move option(s)" do 
				moves = active_pawn.get_valid_moves

				expect(moves[2]).to eql(se_square)
				expect(moves[3]).to eql(sw_square)
			end
		end

		context "when first move, pawn is not blocked, one attacker and one ally diagonal to it" do 
			game = GameBoard.new
			origin = game.square_at([1, 1])
			active_pawn = Pawn.new(game, origin, 'b')
			origin.occupant = active_pawn

			sw_square = game.square_at([2, 0])
			attacker_one = Pawn.new(game, sw_square, 'w')
			sw_square.occupant = attacker_one

			se_square = game.square_at([2, 2])
			ally_one = Pawn.new(game, se_square, 'b')
			se_square.occupant = ally_one

			it "returns an array of length three" do 
				moves = active_pawn.get_valid_moves

				expect(moves.length).to eql(3)
			end

			it "includes diagonal options, but not when occupied by an ally" do 
				moves = active_pawn.get_valid_moves

				expect(moves[2]).to eql(sw_square)
				expect(moves[3]).to eql(nil)
			end
		end
	end
end

describe "Knight" do 

	describe "#get_valid_moves" do 

		context "When knight is in center of board" do 

			it "returns a moveset of length 8" do 
				game = GameBoard.new
				origin = game.square_at([4, 4])
				knight = Knight.new(game, origin, 'w')
				origin.occupant = knight

				expect(knight.get_valid_moves.length).to eql(8)
			end
		end

		context "When knight is in corner" do 

			it "returns a moveset of length 2" do 
				game = GameBoard.new
				origin = game.square_at([0, 0])
				knight = Knight.new(game, origin, 'w')
				origin.occupant = knight
			end
		end
	end
end

describe "King" do 

	describe "#get_valid_moves" do 

		context "When king is in center of empty board" do 

			it "returns a moveset of length 8" do 
				game = GameBoard.new
				origin = game.square_at([4, 4])
				king = King.new(game, origin, 'w')
				origin.occupant = king

				expect(king.get_valid_moves.length).to eql(8)
			end
		end

		context "When king is in center of board" do 

			context "when three potential spots are guarded by opposite color" do 

				it "returns a moveset of length 5" do 
					game = GameBoard.new
					origin = game.square_at([4, 4])
					king = King.new(game, origin, 'w')
					origin.occupant = king

					blocker_sq_one = game.square_at([2, 2])
					pawn_blocker_one = Pawn.new(game, blocker_sq_one, 'b')
					blocker_sq_one.occupant = pawn_blocker_one

					blocker_sq_two = game.square_at([2, 6])
					pawn_blocker_two = Pawn.new(game, blocker_sq_two, 'b')
					blocker_sq_two.occupant = pawn_blocker_two

					rook_square = game.square_at([3, 0])
					rook_blocker = Rook.new(game, rook_square, 'b')
					rook_square.occupant = rook_blocker

					expect(king.get_valid_moves.length).to eql(5)
				end
			end

			context "when all potential spots are guarded by opposite color" do 

				it "returns a moveset of length 0" do 
					game = GameBoard.new
					origin = game.square_at([4, 4])
					king = King.new(game, origin, 'w')
					origin.occupant = king

					sq_one = game.square_at([3, 0])
					rook_one = Rook.new(game, sq_one, 'b')
					sq_one.occupant = rook_one

					sq_two = game.square_at([5, 0])
					rook_two = Rook.new(game, sq_two, 'b')
					sq_two.occupant = rook_two

					sq_three = game.square_at([0, 3])
					rook_three = Rook.new(game, sq_three, 'b')
					sq_three.occupant = rook_three

					sq_four = game.square_at([0, 5])
					rook_four = Rook.new(game, sq_four, 'b')
					sq_four.occupant = rook_four

					expect(king.get_valid_moves.length).to eql(0)
				end
			end
		end
	end
end
