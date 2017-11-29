# frozen_string_literal: false

module Bot
  module Utilities
    # Module for the inrole command
    module IAmNot
      extend Discordrb::Commands::CommandContainer


      command(:iamnot,
              description: 'Removes the role from the current user if it is assignable',
              usage: "#{BOT.prefix}iamnot <role>") do |event, *role_args|
        role = nil
        event.user.roles.each do |serv_role|
          role = serv_role if serv_role.name == role_args.join(' ')
        end

        if role.nil?
          event.channel.send_embed do |embed|
            embed.color = CONFIG.error_embed_color
            embed.description = 'ERROR: That role is not assigned to you'
          end
        else
          if CONFIG.assignable_roles.include? role.name
            event.user.remove_role(role)
            event.channel.send_embed do |embed|
              embed.color = CONFIG.utilities[:embed_color]
              embed.description = "You have removed the role: #{role.name}"
            end
          else
            event.channel.send_embed do |embed|
              embed.color = CONFIG.error_embed_color
              embed.description = 'ERROR: That role is not removeable'
            end
          end
        end
      end
    end
  end
end
