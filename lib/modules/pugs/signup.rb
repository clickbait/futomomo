# frozen_string_literal: false

module Bot
  module Pugs
    # Module for the inrole command
    module Signup
      extend Discordrb::Commands::CommandContainer

      command(:signup,
              description: 'Signs up to the current pending PUG or creates a new PUG',
              usage: "#{BOT.prefix}signup Battletag#1234") do |event, *signup_args|

        bnet = signup_args.join(' ')

        if bnet.include? '#'
          processing = event.channel.send_embed do |embed|
            embed.color = CONFIG.utilities[:embed_color]
            embed.description = "Processing.."
          end
          begin
            rank = 0
            stats = JSON.parse(open("https://owapi.net/api/v3/u/#{bnet.gsub('#', '-')}/stats", {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

            unless stats['us']['stats']['competitive'].nil?
              na_stat = stats['us']['stats']['competitive']['overall_stats']['comprank']
              eu_stat = stats['eu']['stats']['competitive']['overall_stats']['comprank']
              kr_stat = stats['kr']['stats']['competitive']['overall_stats']['comprank']

              rank = [na_stat, eu_stat, kr_stat].max
            end
          rescue OpenURI::HTTPError => ex
            event.channel.send_embed do |embed|
              embed.color = CONFIG.error_embed_color
              embed.description = 'Battletag not found.'
            end

            rank = nil
          end
          processing.delete

          unless rank.nil?
            unless Data::active_session.nil?
              if Data::active_session.players.length < 12
                unless Data::active_session.players.any? {|h| h[:player] == event.user}
                  
                  if Data::active_session.add_player(event.user, rank, bnet)
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
              Data::active_session.add_player(event.user, rank, bnet)
            
              event.channel.send_embed do |embed|
                embed.color = CONFIG.utilities[:embed_color]
                embed.description = "You have started a new PUG (#{Data::active_session.players.length}/12 players)"
              end

              Concurrent::ScheduledTask.new(30*60){ #kill in 30m
                event.channel.send_embed do |embed|
                  embed.color = CONFIG.error_embed_color
                  embed.title = 'ERROR: PUG took too long to start, resetting queue'
                  embed.description = "Feel free to requeue\n\n"

                  Data::active_session.players.each do |player|
                    embed.description << "• #{player[:player].mention} (#{player[:bnet]})\n"
                  end
                end

                Data::active_session = nil
              }.execute
            end

            if Data::active_session.players.length == 12
              Data::active_session.ready = true

              players = Data::active_session.players.sort_by { |v| v[:rank] }.reverse

              event.channel.send_embed do |embed|
                embed.color = CONFIG.utilities[:embed_color]
                embed.title = "PUG Ready! Captains:"
                embed.description = ''

                players[0..1].each do |captain|
                  embed.description << "• #{captain[:player].mention} (#{captain[:bnet]})\n"
                end
              end

              event.channel.send_embed do |embed|
                embed.color = CONFIG.utilities[:embed_color]
                embed.title = "PUG Ready! Available players:"
                embed.description = "Captains, take turns to choose players from the following:\n\n"

                players.slice(2, players.length).each do |player|
                  embed.description << "• #{player[:player].mention} (#{player[:bnet]})\n"
                end
              end

              Data::active_session = nil
            end
          end

        else
          event.channel.send_embed do |embed|
            embed.color = CONFIG.error_embed_color
            embed.description = 'ERROR: Invalid Battletag'
          end
        end
      end
    end
  end
end
