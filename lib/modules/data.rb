# frozen_string_literal: true

module Bot
  # module for loading data files
  module Data
    module_function

    def active_session
    	@active_session
    end

    def active_session= value
  		@active_session = value
  	end
  end
end
