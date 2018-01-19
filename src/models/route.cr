require "granite_orm/adapter/sqlite"

class Route < Granite::ORM::Base
  adapter sqlite
  table_name routes


  # id : Int64 primary key is created for you
  field path : String
  field response : String
end
