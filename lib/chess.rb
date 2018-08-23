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

$invalid_option = "Not a valid option. Please type one of the possible options or 'quit', then press Enter:\n"

$how_to_play = ''

$turn_prompt = 'Select a piece to move, Player '

$select_piece = "Type the coordinate of the piece you wish to move (e.g., A8, E5, B3, etc.): "

$select_destination = "\nType the coordinate of the square you wish to move to (e.g., A8, E5, B3, etc.): "

$valid_rows = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']

$possible_moves = "Potential squares to which this piece can move are highlighted in green:\n"

def to_coord_pair(coord)
	return [(coord[0].ord - 97), (coord[1].to_i - 1)]
end

def bad_input(coord, game)
	case true
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
	when !(moveset.include? game.square_at(to_coord_pair(coord)))
		return false
	when puts_king_in_check(game, piece, game.square_at(to_coord_pair(coord)))
		return false
	else
		return true
	end	
end

def turn(game)
	if game.player_turn == 1
		puts $turn_prompt + game.player_turn.to_s + " (white)."
	else
		puts $turn_prompt + game.player_turn.to_s + " (black)."
	end
	puts $select_piece
	piece_coord = gets.chomp.downcase

	while !valid_piece(piece_coord, game)
		puts $invalid_option
		piece_coord = gets.chomp.downcase
	end

	piece = game.square_at(to_coord_pair(piece_coord)).occupant
	moveset = piece.get_valid_moves

	puts $possible_moves
	game.display_with_options(moveset)

	puts $select_destination
	dest_coord = gets.chomp.downcase

	while !valid_dest(piece, dest_coord, moveset, game)
		puts $invalid_option
		dest_coord = gets.chomp.downcase
	end

	destination = game.square_at(to_coord_pair(dest_coord))
	piece.move(destination)

	if game.player_turn == 1
		king = game.black_pieces[4]
	else
		king = game.white_pieces[4]
	end

	if is_in_check(king.color, game, king.position)
		puts "Check!"
	end

	game.turn_over
	puts "\n  " + "Move: ".on.green + piece.symbol.on.green + ": [".on.green +
		  piece_coord.upcase.on.green + " => ".on.green +
		  (piece.position.coordinates[0] + 97).chr.upcase.on.green +
		  (piece.position.coordinates[1] + 1).to_s.on.green + "]".on.green
	game.display_with_options
end

def play(gameboard)
	puts "     Starting Board:\n".bold
	gameboard.display_with_options

	while !(gameboard.game_over)
		turn(gameboard)
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
			data = nil # load_game function here
			unless !data
				game = nil # load data refactor once data saving is constucted
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