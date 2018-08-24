require './GameBoard.rb'
require './GamePiece.rb'
require './PieceMoves.rb'
require 'JSON'

$load_prompt = "Type the name of the save file (no extensions):\n"
$rewrite_save_prompt = %s{There already exists a file with that name.  Continuing will overwrite the old save data.

(1): Continue anyway and SAVE
(2): Enter a different filename
(3): Cancel
Type the number of the option, then press 'Enter':}
$invalid_save_option = "Not a valid option.  Please type one of the possible options or 'quit', and then press Enter:\n"

module GameTools
	include PieceMoves
	def deep_copy(rows)
		rows_copy = []
		rows.each do |row|
			rows_copy << row.dup
		end
		return rows_copy
	end

	def abs(value)
		case 
		when value == 0
			return 0
		when value < 0
			return value * -1
		else
			return value
		end
	end

	def clean_filename(filename)
		#remove special characters
		filename.gsub!(/[^0-9A-Za-z]/, '')
		puts "Game save file: #{filename}\n"
		return filename
	end

	def valid_save_option(option)
		case option
		when '1', '2', '3', 'quit'
			return true
		else
			return false
		end
	end

	def save_game(data)
		puts $save_prompt
		filename = gets.chomp
		filename = clean_filename(filename)
		Dir.mkdir("../saved_games") unless Dir.exists? "../saved_games"
		if FileTest.file?("../saved_games/#{filename}.csv")
			puts $rewrite_save_prompt
			response = gets.chomp
			while !valid_save_option(response)
				puts $invalid_save_option
				response = gets.chomp
			end
			case response
			when '1'
				File.delete("../saved_games/#{filename}.csv")
				File.open("../saved_games/#{filename}.csv", 'w') {|file| file.write(data)}
			when '2'
				puts "Enter a new filename:\n"
				new_name = gets.chomp
				save_game(data)
			end
		else
			File.open("../saved_games/#{filename}.csv", 'w') {|file| file.write(data)}
		end
	end

	def load_game
		#should return params for GameBoard object if file exists
		puts $load_prompt
		filename = gets.chomp.gsub(/[^0-9A-Za-z]/, '')
		unless !FileTest.file?("../saved_games/#{filename}.csv")
			save_data = JSON.parse(File.read("../saved_games/#{filename}.csv"))
			return save_data
		else
			return false
		end
	end

	def unpack(game, pieces)
		assembled_set = []
		current_piece = nil
		pieces.each do |piece|
			case piece[0]
			when 'pawn'
				current_piece = Pawn.new(game, game.square_at(piece[1]), piece[2])
				current_piece.first_move = piece[3]
				game.square_at(piece[1]).occupant = current_piece
			when 'rook'
				current_piece = Rook.new(game, game.square_at(piece[1]), piece[2])
				current_piece.first_move = piece[3]
				game.square_at(piece[1]).occupant = current_piece
			when 'knight'
				current_piece = Knight.new(game, game.square_at(piece[1]), piece[2])
				game.square_at(piece[1]).occupant = current_piece
			when 'bishop'
				current_piece = Bishop.new(game, game.square_at(piece[1]), piece[2])
				game.square_at(piece[1]).occupant = current_piece
			when 'queen'
				current_piece = Queen.new(game, game.square_at(piece[1]), piece[2])
				game.square_at(piece[1]).occupant = current_piece
			else
				current_piece = King.new(game, game.square_at(piece[1]), piece[2])
				current_piece.first_move = piece[3]
				game.square_at(piece[1]).occupant = current_piece
			end
			assembled_set << current_piece
		end
		if assembled_set[0].color == 'b'
			game.black_pieces = assembled_set
		else
			game.white_pieces = assembled_set
		end
	end

	def assemble(game, black_pieces = nil, white_pieces = nil)
		unless black_pieces
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
		else
			unpack(game, black_pieces)
		end

		unless white_pieces
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

			game.white_pieces = white_pieces
			game.black_pieces = black_pieces
		else
			unpack(game, white_pieces)
		end
		return game
	end

	def puts_king_in_check(game, active_piece, destination)
		mock_game = game.dup
		mock_coords = active_piece.position.coordinates.dup
		mock_piece = mock_game.square_at(mock_coords).occupant
		mock_to = destination.coordinates.dup
		mock_square = mock_game.square_at(mock_to)
		mock_piece.move(mock_square)

		if active_piece.color == 'w'
			return is_in_check('w', mock_game, mock_game.white_pieces[4].position)
		else
			return is_in_check('b', mock_game, mock_game.black_pieces[4].position)
		end
	end

	def get_attacking_path(attacker, king, game)
		path = [attacker.position]
		origin = attacker.position.coordinates
		coord_diff = difference_of_coordinates(king.position.coordinates, attacker.position.coordinates)
		if coord_diff[0] == 0
			diff = coord_diff[1]
			delta = [0, (diff / abs(diff))]
		elsif coord_diff[1] == 0
			diff = coord_diff[0]
			delta = [(diff / abs(diff)), 0]
		else
			diff_x = coord_diff[0]
			diff_y = coord_diff[1]
			delta = [(diff_x / abs(diff_x)), (diff_y / abs(diff_y))]
		end
		loop do 
			origin = combine_coordinates(origin, delta)
			if game.square_at(origin) != king.position
				path << game.square_at(origin)
			else
				break
			end
		end
		return path
	end

	def can_be_blocked(king, game)
		attacking_pieces = []
		if king.color == 'w'
			opposite_piece_set = game.black_pieces
			ally_piece_set = game.white_pieces
		else
			opposite_piece_set = game.white_pieces
			ally_piece_set = game.black_pieces
		end

		opposite_piece_set.each do |piece|
			if (piece.get_valid_moves.include? king.position)
				attacking_pieces << piece
			end
		end

		if attacking_pieces.length > 1
			return false
		end

		if attacking_pieces.length == 1
			unless (attacking_pieces[0].instance_of? Knight)
				attacking_path = get_attacking_path(attacking_pieces[0], king, game)
			else
				attacking_path << attacking_pieces[0].position.coordinates
			end
			ally_piece_set.each do |piece|
				moves = piece.get_valid_moves
				moves.each do |move|
					if (attacking_path.include? move)
						return true
					end
				end
			end
		end
		return false
	end

	def checkmate(king, game)
		if is_in_check(king.color, game, king.position) && 
			(king.get_valid_moves == []) && !(can_be_blocked(king, game))
				game.game_over = true
				return true
		else
			return false
		end
	end
end