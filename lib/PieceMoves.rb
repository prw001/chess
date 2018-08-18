module PieceMoves

	def get_next_coordinates(origin, direction)
		next_coordinates = origin.dup
		case direction
		when 'N'
			next_coordinates[0] -= 1
		when 'NE'
			next_coordinates[1] += 1
			next_coordinates[0] -= 1
		when 'E'
			next_coordinates[1] += 1
		when 'SE'
			next_coordinates[1] += 1
			next_coordinates[0] += 1
		when 'S'
			next_coordinates[0] += 1
		when 'SW'
			next_coordinates[1] -= 1
			next_coordinates[0] += 1
		when 'W'
			next_coordinates[1] -= 1
		when 'NW'
			next_coordinates[1] -= 1
			next_coordinates[0] -= 1
		else
			next_coordinates = nil
		end

		return next_coordinates
	end

	def combine_coordinates(set_one, set_two)
		return [(set_one[0] + set_two[0]), (set_one[1] + set_two[1])]
	end

	def is_in_check(kings_color, game, position)
		game.rows.each do |row|
			row.each do |square|
				if square.occupant && square.occupant.color != kings_color
					moveset = square.occupant.get_valid_moves
					if moveset.include? position
						return true
					end
				end
			end
		end
		return false
	end

	def puts_in_check(color, moveset)

	end
end