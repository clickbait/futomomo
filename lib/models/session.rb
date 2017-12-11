# frozen_string_literal: false

module Bot
  class Session
    attr_accessor :players, :ranks, :ready

    def initialize
      @players = []
      @ready = false
    end

    def add_player(player, rank, bnet)
      unless @players.any? {|h| h[:player] == player}
        @players.push({:player => player, :rank => rank, :bnet => bnet})
      end
    end
  end
end
