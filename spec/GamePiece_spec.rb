require 'GamePiece.rb'
require 'GameBoard.rb'

describe "#take_piece" do 
	context "when one piece attacks another" do 
		defending_piece = GamePiece.new([0, 0])
		attacking_piece = GamePiece.new([1, 1])

		it "removes the defending piece's position" do 
			attacking_piece.take_piece(defending_piece)
			expect(defending_piece.position).to eql(nil)
		end

		it "changes the defender's 'taken' attribute" do 
			expect(defending_piece.is_taken).to eql(true)
		end
	end
end

describe "#move" do 
	context "when a piece is moved" do 
		from_square = ChessSquare.new([0, 0])
		to_square = ChessSquare.new([1, 1])
		active_piece = GamePiece.new(from_square)
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
			passive_piece = GamePiece.new(to_square)
			to_square.occupant = passive_piece
			active_piece.move(to_square)

			expect(active_piece.position).to eql(to_square)
			expect(passive_piece.position).to eql(nil)
			expect(passive_piece.is_taken).to eql(true)
		end
	end
end

