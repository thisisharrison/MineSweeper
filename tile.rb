class Tile
    DELTAS = [
        [-1, -1], [-1, 0], [-1, 1],
        [0, -1], [0, 1],
        [1, -1], [1, 0], [1, 1]
    ]
    
    attr_reader :pos

    def initialize(board, pos)
        @board, @pos = board, pos
        @bombed, @flagged, @revealed = false, false, false
    end

    def plant_bomb
        @bombed = true
    end

    def bombed?
        @bombed
    end

    def flagged?
        @flagged
    end
    
    def revealed?
        @revealed
    end

    def neighbours
        adjacent_coor = DELTAS.map do |dx, dy| 
            [pos[0] + dx, pos[1] + dy]
        end
        adjacent_coor = adjacent_coor.select do |row, col| 
            row <= @board.grid_size - 1 &&
            col <= @board.grid_size - 1
        end
        adjacent_coor.map { |pos| @board[pos] }
    end

    def adjacent_bomb_count
        # neighbour pos, are they bombs
        neighbours.select(&:bombed?).count
    end

    def explore
        return self if flagged?
        return self if revealed?
        @revealed = true

        if !bombed? && adjacent_bomb_count == 0
            neighbours.each(&:explore)
        end
        # why return self? 
        self
    end

    def render
        if flagged?
            "F"
        elsif revealed?
            adjacent_bomb_count == 0 ? "_" : adjacent_bomb_count.to_s
        else
            "*"
        end
    end

    def toggle_flag
        # reverse previous state unless revealed
        @flagged = !@flagged unless @revealed
    end

    def reveal
        if flagged?
            bombed? ? "T" : "F"
        elsif bombed?
            revealed? ? "X" : "B"
        else
            adjacent_bomb_count == 0 ? "_" : adjacent_bomb_count.to_s
        end
    end
end
