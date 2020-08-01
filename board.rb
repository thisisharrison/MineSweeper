require_relative "tile"

class Board
    attr_reader :grid_size, :num_bombs

    def initialize(grid_size, num_bombs)
        @grid_size, @num_bombs = grid_size, num_bombs
        generate_grid
    end

    def generate_grid
        @grid = Array.new(@grid_size) do |row|
            Array.new(@grid_size) { |col| Tile.new(self, [row, col]) }
        end
        plant_bombs
    end

    def plant_bombs
        total_bomb = 0
        while total_bomb < @num_bombs
            pos = Array.new(2) { rand(@grid_size) }
            next if self[pos].bombed?
            self[pos].plant_bomb
            total_bomb += 1
        end
    end

    def [](pos)
        row, col = pos
        @grid[row][col]
    end

    def lost?
        @grid.flatten.any? { |tile| tile.bombed? && tile.revealed? }
    end

    def won?
        # did not reveal any bombed tiles
        @grid.flatten.all? { |tile| tile.bombed? != tile.revealed? }
    end

    def render
        @grid.map do |row|
            row.map do |tile|
                tile.render
            end.join("")
        end.join("\n")
    end

    def game_over
        @grid.map do |row|
            row.map do |tile|
                tile.reveal
            end.join("")
        end.join("\n")
    end
end
