require 'colored2'
require 'JSON'

class GameBoard
	attr_accessor :black_pieces
	attr_accessor :white_pieces
	attr_accessor :game_over
	attr_accessor :player_turn
	attr_accessor :game_log
	attr_reader :rows
	def create_rows
		rows = []
		8.times do |row_index| 
			rows[row_index] = []
			8.times do |column_index|
				rows[row_index][column_index] = ChessSquare.new([row_index, column_index])
			end
		end
		return rows
	end

	def initialize(black_pieces = nil, white_pieces = nil, rows = nil, player_turn = 1, game_log = [])
		unless rows
			@rows = create_rows
		else
			@rows = rows
		end
		@black_pieces = black_pieces
		@white_pieces = white_pieces
		@player_turn = player_turn
		@game_over = false
		@game_log = game_log
	end

	def package_piece(piece)
		label = ''
		case true
		when (piece.is_a? Pawn)
			label = 'pawn'
			return [label, piece.position.coordinates, piece.color, piece.first_move]
		when (piece.is_a? Rook)
			label = 'rook'
			return [label, piece.position.coordinates, piece.color, piece.first_move]
		when (piece.is_a? Knight)
			label = 'knight'
		when (piece.is_a? Bishop)
			label = 'bishop'
		when (piece.is_a? Queen)
			label = 'queen'
		else
			label = 'king'
			return [label, piece.position.coordinates, piece.color, piece.first_move]
		end
		return [label, piece.position.coordinates, piece.color]
	end

	def save_data
		black_set = []
		@black_pieces.each do |piece|
			if piece.is_taken == false
				black_set << package_piece(piece)
			end
		end

		white_set= []
		@white_pieces.each do |piece|
			if piece.is_taken == false
				white_set << package_piece(piece)
			end
		end

		return JSON.generate [black_set, white_set, @player_turn, @game_log]
	end

	def turn_over
		if @player_turn == 1
			@player_turn = 2
		else
			@player_turn = 1
		end
	end

	def square_at(coordinates)
		if (coordinates[0] >= 0 && coordinates[0] < 8) &&
		   (coordinates[1] >= 0 && coordinates[1] < 8)
			return @rows[coordinates[0]][coordinates[1]]
		else
			return nil
		end
	end

	def color(text, row = nil, column = nil)
		if row && column
			if (row % 2 == 0 && column % 2 == 0) || 
			   (row % 2 == 1 && column % 2 == 1)
			   		return text.on.magenta
			else
				return text.on.blue
			end
		else
			return text.on.green
		end
	end

	def display_with_options(moveset = nil)
		row_labels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
		row = 7
		column = 0
		top = "  ┏━━━━━━━━━━━━━━━━━━┓\n"
		bottom = "  ┗━━━━━━━━━━━━━━━━━━┛\n" + "  + 1 2 3 4 5 6 7 8 +\n"
		rows = ""
		while row >= 0
			rows << "#{row_labels[row]} ┃ "
			while column < 8
				unless moveset && (moveset.include? square_at([abs(row-7), column]))
					if square_at([abs(row-7), column]).occupant
						symbol = color(square_at([abs(row-7), column]).occupant.symbol, abs(row-7), column)
					else
					    symbol = color('  ', abs(row-7), column)
					end
				else
					if square_at([abs(row-7), column]).occupant
						symbol = color(square_at([abs(row-7), column]).occupant.symbol)
					else
						symbol = color('  ')
					end
				end
				rows << symbol
				column += 1
			end
			rows << " ┃\n"
			row -= 1
			column = 0
		end
		board = top + rows + bottom
		puts board
	end
end

class ChessSquare
	attr_reader :coordinates
	attr_accessor :occupant
	def initialize(coordinates, occupant = nil)
		@coordinates = coordinates
		@occupant = occupant
	end
end