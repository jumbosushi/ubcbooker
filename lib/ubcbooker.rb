require "pry"
require "mechanize"
require "io/console" # For handling password


module Ubcbooker
  # Stop at 7:14
  # TODO: before 0.1
  # - TDD
  # - Add Optparse lib
  #   - h
  #   - u
  # - Catch when login fails
  # - Feature to save password - do this so you don't have to type everytime
  #   - How to save
  #   - Be able to update the config with -u
  #   take a look into it from like rails perspective
  #   if not just save it as plain text for now
end

require "ubcbooker/version"
require "ubcbooker/http"
require "ubcbooker/cli"
