require "byebug"
require_relative "board"

class Game
    def initialize
        @board = Board.new(9, 10)
    end

    def play
        until @board.won? || @board.lost?
            puts @board.render
            action, pos = get_move
            perform_move(action, pos)
            system("clear")
        end

        if @board.won? 
            puts "You win!"
        elsif @board.lost?
            puts "You lost"
            puts @board.game_over
        end
    end

    def get_move
        puts "Enter your move (e.g. e, 0, 0)"
        action, row, col = gets.chomp.split(",")
        [action, [row.to_i, col.to_i]]
    end

    def perform_move(action, pos)
        
        tile = @board[pos]

        case action
        when "f"
            tile.toggle_flag
        when "e"
            tile.explore
        end
    end
end

if __FILE__ == $PROGRAM_NAME 
    Game.new().play
end
