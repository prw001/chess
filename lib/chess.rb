require 'GameTools.rb'

def play(game)
	game.display
end

def chess
	include GameTools
	game = create()
	play(game)

end


def menu
	chess()
end




menu()