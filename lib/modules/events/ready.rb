# frozen_string_literal: true

module Bot
  module DiscordEvents
    # Module for the Ready event
    module Ready
      extend Discordrb::EventContainer
      ready do |event|
        event.bot.game = Bot::CONFIG.game
      end
    end
  end
end
