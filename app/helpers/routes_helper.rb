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
      if !route["legs"][0]["steps"][1].nil?
        create_route(route, direction_set)
      end
    end
  end

  def create_route(route, direction_set)
    route = route["legs"][0]
    first_step = route["steps"][0]
    last_step = route["steps"][-1]
    trans_detail = route["steps"][1]["transit_details"]
    Route.create(
      direction_set_id: direction_set.id,
      walk_to_dep_time: first_step["duration"]["text"],
      walk_to_dep_desc: first_step["html_instructions"],
      walk_from_arr_time: last_step["duration"]["text"],
      transit_num: trans_detail["line"]["short_name"],
      transit_type: trans_detail["line"]["vehicle"]["type"],
      transit_dep_time: trans_detail["departure_time"]["text"],
      transit_dep_stop: trans_detail["departure_stop"]["name"],
      transit_arr_time: trans_detail["arrival_time"]["text"],
      transit_arr_stop: trans_detail["arrival_stop"]["name"],
      departure_time: route["departure_time"]["text"],
      arrival_time: route["arrival_time"]["text"]
    )
  end
end
