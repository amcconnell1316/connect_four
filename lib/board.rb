class Board 

  def initialize
    @spots = Array.new(6) { Array.new(7, 0) }
  end

  def play_move(player, spot)
    @spots[convert_row(spot)][convert_col(spot)] = player
    @last_move = spot
  end

  def valid_move?(spot)
    spot_row = convert_row(spot)
    spot_col = convert_col(spot)
    return false if chip_exists?(spot_row, spot_col)
    return false if !supported?(spot_row, spot_col)
    true
  end

  def game_over?
    !winner.nil? || full?
  end

  def winner
    return nil if @last_move.nil?

    row = convert_row(@last_move) 
    col = convert_col(@last_move)
    player = @spots[row][col]

    #check 4 in a row
    row_count = 0
    for i in 1..3
      if same_player(player, row, col - i)
        row_count += 1
      else
        break
      end
    end

    for i in 1..3
      if same_player(player, row, col + i)
        row_count += 1
      else
        break
      end
    end

    row_win = (row_count >= 3)
    
    #check 4 in a column
    col_win = same_player(player, row -1 , col) && same_player(player, row - 2, col) && same_player(player, row - 3, col)

    #check 4 forward diagonal
    diag_forward_count = 0
    for i in 1..3
      if same_player(player, row - i, col - i)
        diag_forward_count += 1
      else
        break
      end
    end

    for i in 1..3
      if same_player(player, row + i, col + i)
        diag_forward_count += 1
      else
        break
      end
    end

    diag_forward_win = (diag_forward_count >= 3)

    #check 4 backslash \ diagonal
    diag_back_count = 0
    for i in 1..3
      if same_player(player, row - i, col + i)
        diag_back_count += 1
      else
        break
      end
    end

    for i in 1..3
      if same_player(player, row + i, col - i)
        diag_back_count += 1
      else
        break
      end
    end

    diag_back_win = (diag_back_count >= 3)

    player if row_win || col_win || diag_forward_win || diag_back_win
  end

  def full?
    @spots.all? { |row| row.all? { |spot| spot != 0 } }
  end

  def print_board
    puts '  A B C D E F G'
    @spots.reverse.each_with_index do |row, i|
      row_string = "#{6 -i}|"
      row.each do |spot|
        row_string += spot == 0 ? ' ' : spot
        row_string += '|'
      end
      puts row_string
    end
    puts '  ―――――――――――――'
  end

  private 

  def convert_row(spot)
    spot[1].to_i - 1
  end

  def convert_col(spot)
    spot[0].downcase.ord - 97
  end

  def supported?(row, col)
    return true if row == 0
    return true if chip_exists?(row - 1, col)
    false
  end

  def chip_exists?(row, col)
    @spots[row][col] != 0
  end

  def same_player(player, row, col)
    return false if row < 0 || row > 5 || col < 0 || col > 6

    @spots[row][col] == player
  end


end