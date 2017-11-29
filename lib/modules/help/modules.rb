# frozen_string_literal: false

module Bot
  module Help
    # Module for the modules command
    module Modules
      extend Discordrb::Commands::CommandContainer
      command(%i[modules mdls],
              description: 'Returns a list of all the bot\'s modules',
              usage: "#{BOT.prefix}modules") do |event|
        event.channel.send_embed do |embed|
          embed.title = 'List of futomomo Modules'
          embed.color = CONFIG.help[:embed_color]
          embed.description = ''
          Data::COMMANDS.each_pair.to_a.each do |mod|
            embed.description << "• #{mod.first}\n"
          end
        end
      end
    end
  end
end
