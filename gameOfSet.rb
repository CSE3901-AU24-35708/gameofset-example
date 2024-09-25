class Card
    attr_reader :color, :number, :shape, :shading
  
    def initialize(color, number, shape, shading)
      @color = color
      @number = number
      @shape = shape
      @shading = shading
    end
  
    def to_s
      "#{@number}, #{@color}, #{@shading} #{@shape}"
    end
  end
  
  # class Deck will ensure that the deck will have cards 
  # with different attributes and can deal them as well as a 
  # boolean function to see if the deck is empty
  class Deck
    COLORS = ['red', 'green', 'purple']
    NUMBERS = [1, 2, 3]
    SHAPES = ['oval', 'squiggle', 'diamond']
    SHADINGS = ['solid', 'striped', 'open']
  
    def initialize
      @cards = COLORS.product(NUMBERS, SHAPES, SHADINGS).map { |attrs| Card.new(*attrs) }
      @cards.shuffle!
    end
  
    def deal(num)
      @cards.pop(num)
    end
  
    def is_empty?
      @cards.empty?
    end
  end
  
  class Game
    #sets up the beginning of the game
    def initialize(players)
      @deck = Deck.new
      @board = @deck.deal(12)
      @scores = { 1 => 0, 2 => 0 }
      @players = players
      @current_player = 1
    end
    
    #will start game and change between players. 
    def play
      until @board.empty? || @deck.is_empty?
        puts "Current board:"

        @board.each_with_index do |card, index|
            puts "#{index}: #{card}"
        end

        if @players == 2
        puts "Player #{@current_player}'s turn: Choose indices of a set or type 'q' to quit:"
        input = gets.chomp 
        break if input == 'exit'
        else
            puts "Player 1's turn: Choose indices of a set or type 'q' to quit:"
            input = gets.chomp 
            break if input == 'q'
        end
        
        #deciphers the user's input and evaluates their answer
        indices = input.split.map(&:to_i)
        if valid_indices?(indices) && is_set?(@board.values_at(*indices))
          puts "Set is correct!"
          @scores[@current_player] += 1
          replace_cards(indices)
        else
          puts "Invalid input, try again"
        end
  
        if @current_player == 1
          @current_player = 2
        else
          @current_player = 1
        end
      end   
       
      #prints scores based on how many players
      puts "Game over"
      if @players == 2
        puts "scores:"
        puts "Player 1: #{@scores[1]}"
        puts "Player 2: #{@scores[2]}"
        if @scores[1] > @scores[2]
          puts "Player 1 wins!"
        elsif @scores[1] < @scores[2]
          puts "Player 2 wins!"
        else
          puts "It's a tie!"
        end
        else
         puts "Score for Player 1: #{@scores[1]}"
        end
    end
end

  
    private
  
    def valid_indices?(indices)
      indices.size == 3 && indices.all? { |index| index.between?(0, @board.size - 1) }
    end
  
    def is_set?(cards)
      attributes = cards.map { |card| [card.color, card.number, card.shape, card.shading] }
      # Check if there's at least one attribute where all values are the same
      attributes.transpose.any? { |attr| attr.uniq.size == 1 }
    end
  
    def replace_cards(indices)
      indices.each do |index|
        @board[index] = @deck.empty? ? nil : @deck.deal(1).first
      end
      @board.compact!
      @board += @deck.deal(12 - @board.size) if @board.size < 12 && !@deck.empty?
    end
  
  #Start Game
  puts "Start Game"
  puts "Enter number of players (1 or 2):"
  number_of_players = gets.to_i
  game = Game.new(number_of_players)
  game.play
