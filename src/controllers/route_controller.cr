class RouteController < ApplicationController
  def index
    routes = Route.all
    render("index.ecr")
  end

  def show
    if route = Route.find params["id"]
      render("show.ecr")
    else
      flash["warning"] = "Route with ID #{params["id"]} Not Found"
      redirect_to "/routes"
    end
  end

  def new
    route = Route.new
    render("new.ecr")
  end

  def create
    route = Route.new(route_params.validate!)

    if route.valid? && route.save
      # Add to router
      handler = ->(context : HTTP::Server::Context) {
        context.content = route.response
      }
      amber_route = Amber::Route.new("GET", route.path || "/default", handler)
      Amber::Server.instance.router.add(amber_route)

      flash["success"] = "Created Route successfully."
      redirect_to "/routes"
    else
      flash["danger"] = "Could not create Route!"
      render("new.ecr")
    end
  end

  def edit
    if route = Route.find params["id"]
      render("edit.ecr")
    else
      flash["warning"] = "Route with ID #{params["id"]} Not Found"
      redirect_to "/routes"
    end
  end

  def update
    if route = Route.find(params["id"])
      route.set_attributes(route_params.validate!)
      if route.valid? && route.save
        flash["success"] = "Updated Route successfully."
        redirect_to "/routes"
      else
        flash["danger"] = "Could not update Route!"
        render("edit.ecr")
      end
    else
      flash["warning"] = "Route with ID #{params["id"]} Not Found"
      redirect_to "/routes"
    end
  end

  def destroy
    if route = Route.find params["id"]
      route.destroy
    else
      flash["warning"] = "Route with ID #{params["id"]} Not Found"
    end
    redirect_to "/routes"
  end

  def route_params
    params.validation do
      required(:path) { |f| !f.nil? }
      required(:response) { |f| !f.nil? }
    end
  end
end
