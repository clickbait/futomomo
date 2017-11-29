# frozen_string_literal: true

module Bot
  # module for loading data files
  module Data
    COMMANDS = OpenStruct.new YAML.load_file 'lib/data/commands.yml'
    ACTIVE_SESSION = nil
  end
end
