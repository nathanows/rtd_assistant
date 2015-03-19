module RoutesHelper

  def create_direction_set_routes(response, notification)
    direction_set = create_direction_set(notification)
    create_routes(response, direction_set)
  end

  def create_direction_set(notification)
    DirectionSet.create(notification_id: notification.id)
  end

  def create_routes(response, direction_set)
    response["routes"].each_with_index do |route, i|
      create_route(route, direction_set, (i+1))
    end
  end

  def create_route(route, direction_set, option_num)
    route = route["legs"][0]
    if route["departure_time"].nil?
      new_route = Route.create(
        direction_set: direction_set,
        option_number: option_num,
        start_address: route["start_address"],
        end_address: route["end_address"],
        distance: route["distance"]["text"],
        duration: route["duration"]["text"]
      )
    else
      new_route = Route.create(
        direction_set: direction_set,
        option_number: option_num,
        start_address: route["start_address"],
        end_address: route["end_address"],
        departure_time: route["departure_time"]["text"],
        arrival_time: route["arrival_time"]["text"],
        distance: route["distance"]["text"],
        duration: route["duration"]["text"]
      )
    end

    steps = route["steps"]
    steps.each do |step|
      if step["travel_mode"] == "TRANSIT"
        transit_details = step["transit_details"]
        line = transit_details["line"]
        Step.create(
          route: new_route,
          distance: step["distance"]["text"],
          duration: step["duration"]["text"],
          instructions: step["html_instructions"],
          travel_mode: step["travel_mode"],
          arrival_stop: transit_details["arrival_stop"]["name"],
          arrival_time: transit_details["arrival_time"]["text"],
          departure_stop: transit_details["departure_stop"]["name"],
          departure_time: transit_details["departure_time"]["name"],
          headsign: transit_details["headsign"],
          trans_name: line["name"],
          trans_short_name: line["short_name"],
          trans_type: line["vehicle"]["name"],
          trans_stops: transit_details["num_stops"]
        )
      elsif step["travel_mode"] == "WALKING"
        Step.create(
          route: new_route,
          distance: step["distance"]["text"],
          duration: step["duration"]["text"],
          instructions: step["html_instructions"],
          travel_mode: step["travel_mode"]
        )
      else
        puts "OMG NO!!!!"
      end
    end
  end
end
