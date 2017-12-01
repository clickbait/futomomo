# frozen_string_literal: true

require 'discordrb'
require 'ostruct'
require 'yaml'
require 'concurrent'

# Main Bot module.
module Bot
  Dir['lib/models/*.rb'].each { |mod| load mod }
  Dir['lib/modules/*.rb'].each { |mod| load mod }
  CONFIG = OpenStruct.new YAML.load_file 'lib/data/config.yml'
  BOT = Discordrb::Commands::CommandBot.new(client_id: CONFIG.client_id,
                                            token: CONFIG.token,
                                            prefix:  CONFIG.prefix,
                                            fancy_log: true)

  INVITE_URL = "#{BOT.invite_url}&permissions=#{CONFIG.perms}"

  Discordrb::LOGGER.info 'Now running: futomomo'
  Discordrb::LOGGER.info 'Use ctrl+C to safely exit'
  Discordrb::LOGGER.info "Use this url to invite the bot: #{INVITE_URL}"

  def self.load_module(name, path)
    new_module = Module.new
    const_set(name.to_sym, new_module)
    Dir["lib/modules/#{path}/*.rb"].each { |file| load file }
    new_module.constants.each do |mod|
      BOT.include! new_module.const_get(mod)
    end
  end

  load_module :DiscordEvents, 'events'
  load_module :Pugs, 'pugs'
  load_module(:Utilities, 'utilities') if CONFIG.utilities[:enabled]
  load_module(:Help, 'help') if CONFIG.help[:enabled]

  # capture a keyboard interrupt and gracefully exit
  Signal.trap('INT') do
    Discordrb::LOGGER.info 'Exiting...'
    Discordrb::LOGGER.info 'Have a nice day!'
    exit
  end

  BOT.run
end
