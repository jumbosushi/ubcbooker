require_relative "base_scraper"

module Ubcbooker
  module Scraper
    class CS < Ubcbooker::Scraper::BaseScraper
      def book
        booking_url = BOOKING_URL[:cs]
        booking_page = login(booking_url)
      end

      def login(booking_url)
        @agent.get(booking_url) do |page|
          login_page = page.link_with(text: "CWL Login Redirect").click
          return login_ubc_cwl(login_page)
        end
      end
    end
  end
end
