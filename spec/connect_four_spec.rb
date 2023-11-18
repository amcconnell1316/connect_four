require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe 'play_move' do

    context 'when player x plays a move' do
      it 'spots is updated' do
        board.play_move('x', 'A1')
        spots = board.instance_variable_get(:@spots)
        expect(spots[0][0]).to eq('x')
      end
    end

    context 'when player o plays a move' do
      it 'spots is updated' do
        board.play_move('o', 'D1')
        spots = board.instance_variable_get(:@spots)
        expect(spots[0][3]).to eq('o')
      end
    end

  end

  describe 'valid_move?' do

    context 'when a move is already taken' do
      it 'returns false' do
        spots_taken = Array.new(6) { Array.new(7, 0) }
        spots_taken[0][6] = 'x'
        board.instance_variable_set(:@spots, spots_taken)
        expect(board.valid_move?('G1')).to eq(false)
      end
    end

    context 'when a move is not supported below' do
      it 'returns false' do
        expect(board.valid_move?('A2')).to eq(false)
      end
    end

    context 'when a move is supported by another chip and not taken' do
      it 'returns true' do
        spots_taken = Array.new(6) { Array.new(7, 0) }
        spots_taken[0][6] = 'x'
        board.instance_variable_set(:@spots, spots_taken)
        expect(board.valid_move?('G2')).to eq(true)
      end
    end

    context 'when a move is on the bottom row and not taken' do
      it 'returns true' do
        expect(board.valid_move?('C1')).to eq(true)
      end
    end
  end

  describe 'game_over?' do

    context 'when no last move' do
      it 'returns false' do
        expect(board).to_not be_game_over
      end
    end

    context 'when the last move did not win' do
      it 'returns false' do
        board.play_move('x','A1')
        expect(board).to_not be_game_over
      end
    end

    context 'when the last move the row to the right' do
      before do
        board.play_move('x','G1')
        board.play_move('x','F1')
        board.play_move('x','E1')
        board.play_move('x','D1')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when the last move the row to the left' do
      before do
        board.play_move('x','A1')
        board.play_move('x','B1')
        board.play_move('x','C1')
        board.play_move('x','D1')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when the last move the row in middle' do
      before do
        board.play_move('x','E1')
        board.play_move('x','B1')
        board.play_move('x','C1')
        board.play_move('o','A1')
        board.play_move('o','F1')
        board.play_move('x','D1')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when a row is only partially complete' do
      before do
        board.play_move('x','B1')
        board.play_move('x','C2')
        board.play_move('o','C1')
        board.play_move('o','D1')
      end
      it 'returns false' do
        expect(board).to_not be_game_over
      end
    end

    context 'when the last move wins the column' do
      before do
        board.play_move('o','A1')
        board.play_move('o','A2')
        board.play_move('o','A3')
        board.play_move('o','A4')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when last move puts only 3 in column' do
      before do
        board.play_move('o','A1')
        board.play_move('o','A2')
        board.play_move('o','A3')
      end
      it 'returns false' do
        expect(board).to_not be_game_over
      end
    end

    context 'when the last move completes the top of the backslash \ diagonal' do
      before do
        board.play_move('x','D1')
        board.play_move('x','C2')
        board.play_move('x','B3')
        board.play_move('x','A4')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when the last move completes the bottom of the backslash \ diagonal' do
      before do
        board.play_move('x','A6')
        board.play_move('x','B5')
        board.play_move('x','C4')
        board.play_move('x','D3')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when the last completes the middle of the backslash \ diagonal' do
      before do
        board.play_move('x','B5')
        board.play_move('x','E2')
        board.play_move('x','D3')
        board.play_move('o','A6')
        board.play_move('o','F1')
        board.play_move('x','C4')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when the last move completes the top of the forward slash / diagonal' do
      before do
        board.play_move('o','D2')
        board.play_move('o','E3')
        board.play_move('o','F4')
        board.play_move('o','G5')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when the last move completes the bottom of the forward slash / diagonal' do
      before do
        board.play_move('o','E3')
        board.play_move('o','F4')
        board.play_move('o','G5')
        board.play_move('o','D2')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when the last completes the middle of the forward slash / diagonal' do
      before do
        board.play_move('o','F5')
        board.play_move('o','C2')
        board.play_move('o','D3')
        board.play_move('x','G6')
        board.play_move('x','F1')
        board.play_move('o','E4')
      end
      it 'returns true' do
        expect(board).to be_game_over
      end
    end

    context 'when the  the forward slash / diagonal is partial' do
      before do
        board.play_move('o','C1')
        board.play_move('x','B1')
        board.play_move('x','C2')
      end
      it 'returns false' do
        expect(board).to_not be_game_over
      end
    end

    context 'when the board is full' do
      it 'returns true' do
        spots_full = Array.new(6) { Array.new(7, 'x') }
        board.instance_variable_set(:@spots, spots_full)
        expect(board).to be_game_over
      end
    end

  end
end
