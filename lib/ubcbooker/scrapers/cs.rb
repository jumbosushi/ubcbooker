module Ubcbooker
  module Scraper
    class Cs < BaseScraper
      CS_ROOM_BASE_URL = "https://my.cs.ubc.ca/space/"
      CS_ROOMS = ["x139", "x141", "x151", "x153", # 1st Floor
                  "x237", "x239", "x241",         # 2nd Floor
                  "x337", "x339", "x341"]         # 3rd Floor

      def get_room_cal_url(room)
        if CS_ROOMS.include?(room)
          return CS_ROOM_BASE_URL + "ICCS" + room.capitalize
        else
          raise Ubcbooker::Error::InvalidRoom
        end
      end

      def book
        booking_url = BOOKING_URL[:cs]
        booking_page = login(booking_url)
        binding.pry
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
