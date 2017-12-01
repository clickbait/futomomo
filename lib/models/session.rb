# frozen_string_literal: false

module Bot
  class Session
    attr_accessor :players, :ready

    def initialize
      @players = []
      @ready = false
    end

    def add_player(player)
      @players.push(player) unless @players.include? player
    end
  end
end
