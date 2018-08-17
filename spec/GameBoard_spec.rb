require 'GameBoard.rb'
game_board = GameBoard.new
describe "#create_rows" do

	rows = game_board.create_rows 

	it "returns an array" do 
		expect(rows).to be_an_instance_of(Array)
	end

	it "returns an array of length 8" do 
		expect(rows.length).to eql(8)
	end

	it "fills each subarray with ChessSquares" do 
		expect(rows[0][0]).to be_an_instance_of(ChessSquare)
	end
end

describe "#square_at" do 
	
	context "given coordinates" do 
		it "returns a square" do 
			expect(game_board.square_at([1, 2])).to be_an_instance_of(ChessSquare)
		end
	end

	context "given coordinates outside the gameboard" do 
		it "returns nil" do 
			expect(game_board.square_at([-1, 3])).to eql(nil)
		end
	end
end

