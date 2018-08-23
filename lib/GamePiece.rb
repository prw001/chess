require './PieceMoves.rb'
require './GameBoard.rb'
require './GameTools.rb'
require 'colored2'

class GamePiece
	attr_accessor :position
	attr_reader :is_taken
	attr_reader :color
	def initialize(game, position, color)
		@position = position
		@is_taken = false
		@color = color
		@game = game
	end

	def gets_taken
		@position = nil
		@is_taken = true
	end

	def take_piece(piece)
		piece.gets_taken
	end

	def get_valid_moves(directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'])
		moves = []
		directions.each do |direction|
			next_coord = @position.coordinates.dup
			loop do 
				next_coord = get_next_coordinates(next_coord, direction)
				if @game.square_at(next_coord)
					if @game.square_at(next_coord).occupant == nil
						moves << @game.square_at(next_coord)
					elsif @game.square_at(next_coord).occupant.color != @color
						moves << @game.square_at(next_coord)
						break
					else
						break
					end
				else
					break
				end
			end	
		end
		return moves	
	end

	def move(to_square)
		if to_square.occupant.instance_of? GamePiece
			take_piece(to_square.occupant)
		end
		@position.occupant = nil
		@position = to_square
		to_square.occupant = self
	end
end

class Pawn < GamePiece
	attr_accessor :first_move
	attr_reader :symbol
	include PieceMoves
	def initialize(game, position, color)
		super(game, position, color)
		@first_move = true
		if @color == 'w'
			@symbol = '♙ '.white
		else
			@symbol = '♟ '
		end
	end

	def move(to_square)
		super
		@first_move = false
	end

	def get_valid_moves
		moveset = []
		next_coord = @position.coordinates.dup

		@color == 'w' ? directions = ['N', 'NE', 'NW'] : directions = ['S', 'SE', 'SW']
		@first_move == true ? move_delta = 2 : move_delta = 1

		move_delta.times do #vertical moves
			next_coord = get_next_coordinates(next_coord, directions[0])
			next_square = @game.square_at(next_coord)
			if next_square && !(next_square.occupant)
				moveset << next_square
			else
				break
			end
		end

		2.times do |index| #diagonal attacks
			origin = @position.coordinates.dup
			next_square = @game.square_at(get_next_coordinates(origin, directions[index + 1]))
			if next_square && next_square.occupant && 
			   next_square.occupant.color != @color
					moveset << next_square
			end
		end

		return moveset
	end
end

class Rook < GamePiece
	attr_accessor :first_move
	attr_reader :symbol
	include PieceMoves
	def initialize(game, position, color)
		super(game, position, color)
		@first_move = true
		if @color == 'w'
			@symbol = '♖ '.white
		else
			@symbol = '♜ '
		end
	end

	def move(to_square)
		super
		@first_move = false
	end

	def get_valid_moves(directions = ['N', 'E', 'S', 'W'])
		super
	end
end

class Knight < GamePiece
	attr_reader :symbol
	include PieceMoves
	def initialize(game, position, color)
		super(game, position, color)
		if @color == 'w'
			@symbol = '♘ '.white
		else
			@symbol = '♞ '
		end
	end

	def get_valid_moves
		moveset = []
		coord_shifts = [[2, -1], [2, 1],
				[1, 2], [-1, 2],
				[-2, 1], [-2, -1],
				[1, -2], [-1, -2]]

		coord_shifts.each do |shift|
			next_square = @game.square_at(combine_coordinates(@position.coordinates, shift))
			if next_square && next_square.occupant == nil
				moveset << next_square
			elsif next_square && next_square.occupant && next_square.occupant.color != @color
				moveset << next_square
			else
				next
			end
		end
		return moveset
	end
end

class Bishop < GamePiece
	attr_reader :symbol
	include PieceMoves
	def initialize(game, position, color)
		super(game, position, color)
		if @color == 'w'
			@symbol = '♗ '.white
		else
			@symbol = '♝ '
		end
	end

	def get_valid_moves(directions = ['NW', 'SE', 'SW', 'NE'])
		super
	end
end

class Queen < GamePiece
	attr_reader :symbol
	include PieceMoves
	def initialize(game, position, color)
		super(game, position, color)
		if @color == 'w'
			@symbol = '♕ '.white
		else
			@symbol = '♛ '
		end
	end
end

class King < GamePiece
	attr_reader :symbol
	attr_accessor :first_move
	include PieceMoves
	def initialize(game, position, color)
		super(game, position, color)
		@first_move = true
		if @color == 'w'
			@symbol = '♔ '.white
		else
			@symbol = '♚ '
		end
	end

	def move(to_square)
		super
		@first_move = false
	end

	def get_valid_moves(directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'])
		moveset = []
		origin = @position.coordinates
		directions.each do |direction|
			next_square = @game.square_at(get_next_coordinates(origin, direction))
			if next_square && next_square.occupant == nil &&
			   !(is_in_check(@color, @game, next_square)) &&
			   !(pawn_is_blocking(@color, @game, next_square))
					moveset << next_square
			elsif next_square && next_square.occupant && 
				  next_square.occupant.color != @color &&
				  !(is_in_check(@color, @game, next_square)) &&
				  !(pawn_is_blocking(@color, @game, next_square))
				  	moveset << next_square
			else
				next
			end
		end
		return moveset
	end
end
