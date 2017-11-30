# frozen_string_literal: false

module Bot
  module Utilities
    # Module for the inrole command
    module IAm
      extend Discordrb::Commands::CommandContainer


      command(:iam,
              description: 'Assign a role if it is assignable',
              usage: "#{BOT.prefix}iam <role>") do |event, *role_args|
        role = nil
        event.server.roles.each do |serv_role|
          role = serv_role if serv_role.name.downcase == role_args.join(' ').downcase
        end

        if role.nil?
          event.channel.send_embed do |embed|
            embed.color = CONFIG.error_embed_color
            embed.title = 'ERROR: That role does not exist'
            embed.description = "**Assignable roles:**\n"

            CONFIG.assignable_roles.each do |role|
              embed.description << "• #{role}\n"
            end
          end
        else
          if CONFIG.assignable_roles.include? role.name
            event.user.add_role(role)
            event.channel.send_embed do |embed|
              embed.color = CONFIG.utilities[:embed_color]
              embed.description = "You have been assigned the role: #{role.name}"
            end
          else
            event.channel.send_embed do |embed|
              embed.color = CONFIG.error_embed_color
              embed.description = 'ERROR: That role is not assignable'
            end
          end
        end
      end
    end
  end
end
