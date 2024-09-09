require_relative 'player'

class PlayerCreator

    def get_players
        puts 'enter player 1 name'
        player_1_name = gets.chomp
        puts 'enter player 2 name'
        player_2_name = gets.chomp

        [Player.new(player_1_name), Player.new(player_2_name)]
    end
end