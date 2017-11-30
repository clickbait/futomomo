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
          role = serv_role if serv_role.name.downcase == role_args.join(' ').downcase
        end

        if role.nil?
          event.channel.send_embed do |embed|
            embed.color = CONFIG.error_embed_color
            embed.title = 'ERROR: That role is not assigned to you'
            embed.description = "**Your removeable roles:**\n"

            event.user.roles.each do |role|
              embed.description << "• #{role.name}\n" if CONFIG.assignable_roles.include? role.name
            end
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
              embed.title = 'ERROR: That role is not removeable'
              embed.description = "**Your removeable roles:**\n"

              event.user.roles.each do |role|
                embed.description << "• #{role.name}\n" if CONFIG.assignable_roles.include? role.name
              end
            end
          end
        end
      end
    end
  end
end
