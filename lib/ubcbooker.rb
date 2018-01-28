require "pry"
require "mechanize"
require "io/console" # For handling password
require "optparse"
require "yaml"

module Ubcbooker
  # TODO: before 0.1
  # - TDD
  # - Catch when login fails
  # - Selection with arrow keys
  SUPPORTED_DEPARTMENTS = [
    "cs",
    "sauder",
  ]
end

require "ubcbooker/version"
require "ubcbooker/error"
require "ubcbooker/color"
require "ubcbooker/config"
require "ubcbooker/http"
require "ubcbooker/cli"
