require "./spec_helper"

def route_hash
  {"path" => "Fake", "response" => "Fake"}
end

def route_params
  params = [] of String
  params << "path=#{route_hash["path"]}"
  params << "response=#{route_hash["response"]}"
  params.join("&")
end

def create_route
  model = Route.new(route_hash)
  model.save
  model
end

class RouteControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :web do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
      plug Amber::Pipe::Flash.new
    end
    @handler.prepare_pipelines
  end
end

describe RouteControllerTest do
  subject = RouteControllerTest.new

  it "renders route index template" do
    Route.clear
    response = subject.get "/routes"

    response.status_code.should eq(200)
    response.body.should contain("Routes")
  end

  it "renders route show template" do
    Route.clear
    model = create_route
    location = "/routes/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Route")
  end

  it "renders route new template" do
    Route.clear
    location = "/routes/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Route")
  end

  it "renders route edit template" do
    Route.clear
    model = create_route
    location = "/routes/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Route")
  end

  it "creates a route" do
    Route.clear
    response = subject.post "/routes", body: route_params

    response.headers["Location"].should eq "/routes"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a route" do
    Route.clear
    model = create_route
    response = subject.patch "/routes/#{model.id}", body: route_params

    response.headers["Location"].should eq "/routes"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a route" do
    Route.clear
    model = create_route
    response = subject.delete "/routes/#{model.id}"

    response.headers["Location"].should eq "/routes"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
