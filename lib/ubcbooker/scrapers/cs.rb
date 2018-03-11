module Ubcbooker
  module Scraper
    class Cs < BaseScraper
      CS_ROOM_BASE_URL = "https://my.cs.ubc.ca/space/"
      CS_BOOK_URL = "https://my.cs.ubc.ca/node/add/pr-booking"
      CS_ROOMS = ["X139", "X141", "X151", "X153", # 1st Floor
                  "X237", "X239", "X241",         # 2nd Floor
                  "X337", "X339", "X341"]         # 3rd Floor

      def book(options)
        login
        title = options[:name]
        book_date = Date.parse(options[:date])
        book_slot = get_time_slot(options[:time])

        room_pages = batch_request(CS_ROOMS, book_date)
        room_pages.select! { |r| is_available(r, book_date, book_slot) }

        if room_pages.any?
          # TODO: If -c CHOOSE option then run CLI-UI here
          room = room_pages.first  # Choose the first available room
          submit_booking(room, title, book_date, book_slot)
          return get_room_page_id(room)
        else
          raise Ubcbooker::Error::NoAvailableRoom.new(options[:time])
        end
      end

      def login
        spinner = get_spinner("Logging into CWL")
        booking_url = BOOKING_URL[:cs]
        @agent.get(booking_url) do |page|
          login_page = page.link_with(text: "CWL Login Redirect").click
          login_ubc_cwl(login_page)
        end
        spinner.success("Done!") # Stop animation
      end

      def submit_booking(room, title, book_date, book_slot)
        spinner = get_spinner("Submitting booking request")
        booking_form = @agent.get(CS_BOOK_URL).forms[1]
        booking_form["title"] = title
        book_date_str = book_date.strftime("%Y/%m/%d")  # ex 2018/03/08
        select_room_option(booking_form, room)
        booking_form["field_date[und][0][value][date]"] = book_date_str
        booking_form["field_date[und][0][value][time]"] = time_to_ampm(book_slot.min)
        booking_form["field_date[und][0][value2][date]"] = book_date_str
        booking_form["field_date[und][0][value2][time]"] = time_to_ampm(book_slot.max)
        spinner.success("Done!")
        booking_form.submit
      end

      # Select the form otpion with right room id
      def select_room_option(booking_form, page)
        room_id = get_room_page_id(page)
        select_options = booking_form.field_with(name: "field_space_project_room[und]").options
        select_options.each do |o|
          if o.text.include?(room_id)
            o.click
          end
        end
      end

      def get_room_page_id(page)
        return page.form.action.split("/").last
      end

      def batch_request(room_list, book_date)
        cookie = @agent.cookies.join("; ")
        spinner = get_spinner("Checking room availabilities")

        hydra = Typhoeus::Hydra.new
        requests = room_list.map do |room_id|
          room_url = get_room_cal_url(book_date, room_id)
          request = Typhoeus::Request.new(room_url, headers: { Cookie: cookie })
          hydra.queue(request)
          request
        end
        hydra.run # Start requests
        spinner.success("Done!")
        return typhoeus_to_mechanize(requests)
      end

      def get_room_cal_url(book_date, room_id)
        if CS_ROOMS.include?(room_id)
          room_url = CS_ROOM_BASE_URL + "ICCS" + room_id
          if is_next_month(book_date)
            today = Date.today
            month_query = "?month=" + today.year + "-" + (today.month + 1)
            return room_url + month_query
          else
            return room_url
          end
        end
      end

      # Turn typhoneus obj to mechanize page obj
      def typhoeus_to_mechanize(requests)
        pages = requests.map do |request|
          html = request.response.body
          Mechanize::Page.new(nil, {"ontent-type" => "text/html"}, html, nil, @agent)
        end
        return pages
      end

      def is_next_month(date)
        return date.month != Date.today.month
      end

      def is_available(room_page, book_date, book_slot)
        slot_booked = get_slot_booked(room_page, book_date)
        return !is_slot_booked(slot_booked, book_slot)
      end

      def is_slot_booked(slot_booked, book_slot)
        booked = false
        slot_booked.each do |s|
          if s.include?(book_slot)
            booked = true
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
        (0..slot_num-1).each do |i|
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

      def get_spinner(text)
        spinner = ::TTY::Spinner.new("[:spinner] #{text} ... ", format: :dots)
        spinner.auto_spin # Automatic animation with default interval
        return spinner
      end

      # =========================
      # Time operations

      # Expect HH:MM-HH:MM
      def get_time_slot(time_str)
        times = time_str.split("-")
        return (times[0]..times[1])
      end

      # 05:00pm -> 17:99
      def ampm_to_time(str)
        time = Time.parse(str)
        return time.strftime("%H:%M")
      end

      # 17:00 -> 05:00pm
      def time_to_ampm(str)
        time = Time.parse(str)
        return time.strftime("%I:%M%P")
      end
    end
  end
end
