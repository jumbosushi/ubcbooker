require "bundler/setup"
require "ubcbooker"

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Allow exit to happen within the code
  config.around(:example) do |ex|
    begin
      ex.run
    rescue SystemExit => e
      puts "Got SystemExit: #{e.inspect}. Ignoring"
    end
  end
end
