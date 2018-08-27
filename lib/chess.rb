require './GameTools.rb'
require './GamePiece.rb'
require './PieceMoves.rb'
require 'colored2'

$title = %s{
****************************************************************
**********///===\*|*||***||**||====\**//===*\***//===*\*********
*********|||********||***||**||*******||********||**************
*********|||********||***||**||*******\|********\|**************
*********|||********||===||**||====|***\====\****\====\*********
*********|||********||***||**||*************|\********|\********
*********|||*****_**||***||**||********_****||***_****||********
*********'*\====/*|*||***||**||====/***`\===//***`\===//********
****************************************************************


}

$welcome_prompt = "Welcome to Chess!"

$options = %s{Please select one of the following options:

Option (1): New Game
Option (2): Load Game
Option (3): Exit

}

$save_prompt = "Type a name for your save file (no special characters):\n"

$invalid_option = "Not a valid option. Please type one of the possible options or 'quit', and then press Enter:\n"

$how_to_play = ''

$leaves_king_in_check = "That move leaves your king in check and is not legal. You must either:\n"+
						"-Move the king to another location\n-Block the attacking piece\n"+
						"-Take the attacking piece\n-Type 'back' to select another piece.\n"

$turn_prompt = 'Select a piece to move, Player '

$select_piece = "Type the coordinate of the piece you wish to move (e.g., A8, E5, B3, etc.): "

$select_destination = "\nType the coordinate of the square you wish to move to (e.g., A8, E5, B3, etc.)."+
					  "\nOr type 'back' to select a different piece."

$valid_rows = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']

$possible_moves = "Potential squares to which this piece can move are highlighted in green:\n"

def bad_input(coord, game)
	case true
	when coord == 'quit' || coord == 'save' || coord == 'back'
		return false
	when !($valid_rows.include? coord[0])
		return true
	when (coord[1].to_i == 0 || coord[1].to_i < 0 || coord[1].to_i > 8)
		return true
	when coord.length > 2
		return true
	else
		return false
	end
end

def valid_piece(coord, game)
	case true 
	when bad_input(coord, game)
		return false
	when coord == 'back'
		return false
	when coord == 'save' || coord == 'quit'
		return true
	when !(game.square_at(to_coord_pair(coord)).occupant)
		return false
	when game.player_turn == 1 && game.square_at(to_coord_pair(coord)).occupant.color != 'w'
		return false
	when game.player_turn == 2 && game.square_at(to_coord_pair(coord)).occupant.color != 'b'
		return false
	else
		return true
	end
end

def valid_dest(piece, coord, moveset, game)
	case true
	when bad_input(coord, game)
		return false
	when coord == 'quit' || coord == 'save' || coord == 'back'
		return true
	when !(moveset.include? game.square_at(to_coord_pair(coord)))
		return false
	when puts_king_in_check(game, piece, (to_coord_pair(coord)))
		puts $leaves_king_in_check
		return false
	else
		return true
	end	
end

def last_move(start, stop, piece)
	move = "Move: #{piece.symbol.on.green} : [#{start.upcase} => #{stop.upcase}]"
	return move
end

def move_piece(gameboard, dest_coord, piece)
	destination = gameboard.square_at(to_coord_pair(dest_coord))
	piece.move(destination)

	if gameboard.player_turn == 1
		king = gameboard.black_pieces.find{|piece| piece.instance_of? King}
	else
		king = gameboard.white_pieces.find{|piece| piece.instance_of? King}
	end

	if checkmate(king, gameboard)
		puts "         " + "Checkmate!".bold.white.on.red
	elsif is_in_check(king.color, gameboard, king.position)
		puts "         " + "Check!".bold.white.on.red
		gameboard.turn_over
	else
		gameboard.turn_over
	end
end

def select_destination(gameboard, piece)
	moveset = piece.get_valid_moves
	puts $possible_moves
	gameboard.display_with_options(moveset)

	puts $select_destination
	dest_coord = gets.chomp.downcase

	while !valid_dest(piece, dest_coord, moveset, gameboard)
		puts $invalid_option
		dest_coord = gets.chomp.downcase
	end

	if dest_coord.length == 2
		move_piece(gameboard, dest_coord, piece)
	end
	return dest_coord
end

def select_piece(gameboard)
	puts $select_piece
	piece_coord = gets.chomp.downcase

	while !valid_piece(piece_coord, gameboard)
		puts $invalid_option
		piece_coord = gets.chomp.downcase
	end

	if piece_coord.length == 2
		piece = gameboard.square_at(to_coord_pair(piece_coord)).occupant
		return piece
	else
		return piece_coord
	end
end

def turn(gameboard)
	if gameboard.player_turn == 1
		puts $turn_prompt + gameboard.player_turn.to_s + " (white)."
	else
		puts $turn_prompt + gameboard.player_turn.to_s + " (black)."
	end

	option = select_piece(gameboard)

	case option
	when 'quit'
		gameboard.game_over = true
	when 'save'
		data = gameboard.save_data
		save_game(data)
	else
		start_square = from_coord_pair(option.position.coordinates)
		destination = select_destination(gameboard, option)
	end

	case destination
	when 'quit'
		gameboard.game_over = true
	when 'save'
		data = gameboard.save_data
		save_game(data)
	when 'back'
		puts "     Current Board:\n".bold
		gameboard.display_with_options
		turn(gameboard)
	else
		unless !destination
			gameboard.game_log << last_move(start_square, destination, option)
			puts gameboard.game_log[-1]
			gameboard.display_with_options
		end
	end
end

def play(gameboard)
	puts "     Starting Board:\n".bold
	gameboard.display_with_options

	while !(gameboard.game_over)
		turn(gameboard)
	end
	puts "     Moves:".bold
	gameboard.game_log.each_with_index do |move, index|
		puts "(#{index + 1}): #{move}"
	end
end

def chess(gameboard = nil)
	include GameTools
	unless gameboard
		gameboard = assemble(GameBoard.new)
	end
	play(gameboard)
end

def valid_option(option = nil)
	case option
	when '1', '2', '3', 'quit'
		return option
	else
		return nil
	end
end

def menu
	include GameTools
	wants_to_play = true
	game = nil
	puts $title
	puts $welcome_prompt
	
	while wants_to_play
		puts $options
		option = gets.chomp.downcase

		while !(valid_option(option))
			puts $invalid_option
			option = gets.chomp.downcase
		end

		case option
		when '1'
			chess
		when '2'
			data = load_game
			unless !data
				game = assemble(GameBoard.new, data[0], data[1])
				game.player_turn = data[2]
				game.game_log = data[3]
				chess(game)
			else
				puts "\nFailed to load game, try again or a different filename.\n".red
			end
		else
			wants_to_play = false
			puts "Goodbye!"
		end
	end
end

menu()