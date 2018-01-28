require "pry"
require "mechanize"
require "io/console" # For handling password
require "optparse"
require "yaml"

module Ubcbooker
  # Stop at 7:14
  # TODO: before 0.1
  # - TDD
  # - Catch when login fails
  SUPPORTED_DEPARTMENTS = [
    "cs",
    "sauder",
  ]
end

require "ubcbooker/version"
require "ubcbooker/color"
require "ubcbooker/config"
require "ubcbooker/http"
require "ubcbooker/cli"
