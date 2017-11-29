# frozen_string_literal: false

module Bot
  module Utilities
    # Module for the inrole command
    module Signup
      extend Discordrb::Commands::CommandContainer


      command(:signup,
              description: 'Signs up to the current pending PUG or creates a new PUG',
              usage: "#{BOT.prefix}signup") do |event|
        unless Data::ACTIVE_SESSION.nil?
          if Data::ACTIVE_SESSION.players.length < 12
            Data::ACTIVE_SESSION.players.push(event.user)

            #player in queue alert
          else
            #error
          end
        else
          Data::ACTIVE_SESSION = Session.new
          Data::ACTIVE_SESSION.players.push(event.user)
          # setup timer
          #start session alert
        end

        if Data::ACTIVE_SESSION.players.length == 12
          Data::ACTIVE_SESSION.ready = true
          # pug start alert!
        end
      end
    end
  end
end
