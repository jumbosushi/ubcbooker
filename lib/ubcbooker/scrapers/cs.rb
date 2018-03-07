module Ubcbooker
  module Scraper
    class Cs < BaseScraper
      CS_ROOM_BASE_URL = "https://my.cs.ubc.ca/space/"
      CS_ROOMS = ["x139", "x141", "x151", "x153", # 1st Floor
                  "x237", "x239", "x241",         # 2nd Floor
                  "x337", "x339", "x341"]         # 3rd Floor

      # TODO: Turn today_date into instance var
      def get_room_cal_url(book_date, room)
        if CS_ROOMS.include?(room)
          room_url = CS_ROOM_BASE_URL + "ICCS" + room
          if is_next_month(book_date)
            today = Date.today
            month_query = "?month=" + today.year + "-" + (today.month + 1)
            return room_url + month_query
          else
            return room_url
          end
        else
          raise Ubcbooker::Error::InvalidRoom
        end
      end

      # TODO:
      # Book the first available room
      def book(options)
        booking_url = BOOKING_URL[:cs]
        book_date = Date.parse(options[:date])
        book_slot = get_time_slot(options[:time])
        booking_page = login(booking_url)
        room_url = get_room_cal_url(book_date, "x139")
        room_page = @agent.get(room_url)
        slot_booked = get_slot_booked(room_page, book_date)

        if !is_slot_booked(slot_booked, book_slot)
          # TODO
          # Booking form submission
          binding.pry
        end
      end

      def login(booking_url)
        @agent.get(booking_url) do |page|
          login_page = page.link_with(text: "CWL Login Redirect").click
          return login_ubc_cwl(login_page)
        end
      end

      # Expect HH:MM-HH:MM
      def get_time_slot(time_str)
        times = time_str.split("-")
        return (times[0]..times[1])
      end


      def is_next_month(date)
        return date.month != Date.today.month
      end

      def is_slot_booked(slot_booked, book_slot)
        booked = false
        slot_booked.each do |s|
          if s.include?(book_slot)
            booked = false
          end
        end
        return booked
      end

      def get_slot_booked(room_page, book_date)
        day_div_id = get_date_div_id(book_date)
        day_div = room_page.search("td##{day_div_id}").first
        slot_num = day_div.search("div.item").size
        start_times = day_div.search("span.date-display-start")
        end_times = day_div.search("span.date-display-end")

        slot_booked = []
        for i in 0..slot_num-1
          slot_start = ampm_to_time(start_times[i].text) # 01:00
          slot_end = ampm_to_time(end_times[i].text) # 05:00
          slot_booked.push((slot_start..slot_end))
        end
        return slot_booked
      end

      def get_date_div_id(date)
        date_div_base = "calendar_space_entity_project_room-"
        date_div_base += "#{date.year}-#{date.strftime("%m")}-#{date.strftime("%d")}-0"
        return date_div_base
      end

      def ampm_to_time(str)
        period = str[-2, 2]
        time = Time.parse(str[0, 5])
        # Add 12 hours if pm
        if period == "pm" &&  str != "12:00pm"
          time = time + 12*60*60
        end
        return time.strftime("%H:%M")
      end
    end
  end
end
