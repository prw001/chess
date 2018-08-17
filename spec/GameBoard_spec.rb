require 'GameBoard.rb'

describe "#create_rows" do
	game_board = GameBoard.new
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
