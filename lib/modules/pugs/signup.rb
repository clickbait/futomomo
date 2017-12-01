# frozen_string_literal: false

module Bot
  module Pugs
    # Module for the inrole command
    module Signup
      extend Discordrb::Commands::CommandContainer


      command(:signup,
              description: 'Signs up to the current pending PUG or creates a new PUG',
              usage: "#{BOT.prefix}signup") do |event|
        unless Data::active_session.nil?
          if Data::active_session.players.length < 12
            unless Data::active_session.players.include? event.user
              
              if Data::active_session.add_player(event.user)
                event.channel.send_embed do |embed|
                  embed.color = CONFIG.utilities[:embed_color]
                  embed.description = "You have been added to the next PUG (#{Data::active_session.players.length}/12 players)"
                end
              end
            end

          else
              event.channel.send_embed do |embed|
                embed.color = CONFIG.error_embed_color
                embed.description = 'ERROR: Already 12 players in this session'
              end
          end
        else
          Data::active_session = Session.new
          Data::active_session.add_player(event.user)
        
          event.channel.send_embed do |embed|
            embed.color = CONFIG.utilities[:embed_color]
            embed.description = "You have started a new PUG (#{Data::active_session.players.length}/12 players)"
          end

          Concurrent::ScheduledTask.new(30*60){ #kill in 30m
            event.channel.send_embed do |embed|
              embed.color = CONFIG.error_embed_color
              embed.description = 'ERROR: PUG took too long to start, resetting queue'
            end

            Data::active_session = nil
          }.execute
        end

        if Data::active_session.players.length == 12
          Data::active_session.ready = true
          # pug start alert!
        end
      end
    end
  end
end
