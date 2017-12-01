# frozen_string_literal: true

module Bot
  # module for loading data files
  module Data
    COMMANDS = OpenStruct.new YAML.load_file 'lib/data/commands.yml'

    module_function

    def active_session
    	@active_session
    end

    def active_session= value
  		@active_session = value
  	end
  end
end
