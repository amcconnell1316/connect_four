require_relative '../lib/game'
require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe 'game_over?' do
    context 'last move did not win' do
      xit 'returns false' do
        expect(board.game_over?).to eq(false)
      end
    end

    context 'last move won' do
      xit 'returns true' do
        expect(board.game_over?).to eq(true)
      end
    end

  end
end

describe Game do
end