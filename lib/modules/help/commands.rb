# frozen_string_literal: false

module Bot
  module Help
    # Module for the Commands command
    module Commands
      extend Discordrb::Commands::CommandContainer
      command(%i[commands cmds],
              description: 'Returns a list of commands in the given module',
              usage: "#{BOT.prefix}cmds <module>") do |event, mod_arg|
        modul = Data::COMMANDS.each_pair.find do |mod|
          mod.first.to_s.casecmp? mod_arg
        end
        event.channel.send_embed do |embed|
          embed.title = "Commands for the #{modul.first} module"
          embed.color = CONFIG.help[:embed_color]
          embed.description = ''
          modul.last.each_key do |key|
            embed.description << "• #{key}\n"
          end
        end
      end
    end
  end
end
