# frozen_string_literal: false

module Bot
  module Utilities
    # Module for the inrole command
    module HasRole
      extend Discordrb::Commands::CommandContainer


      command(:hasrole,
              description: 'Shows a list of all the users in the given role',
              usage: "#{BOT.prefix}hasrole <role>") do |event, *role_args|
        role = nil
        event.server.roles.each do |serv_role|
          role = serv_role if serv_role.name == role_args.join(' ')
        end

        if role.nil?
          event.channel.send_embed do |embed|
            embed.color = CONFIG.error_embed_color
            embed.description = 'ERROR: That role does not exist'
          end
        else
          event.channel.send_embed do |embed|
            embed.color = CONFIG.utilities[:embed_color]
            embed.title = "Users with role: #{role.name}"
            embed.description = ''

            role.members.each do |member|
              embed.description << "• #{member.name}\n"
            end
          end
        end
      end
    end
  end
end
