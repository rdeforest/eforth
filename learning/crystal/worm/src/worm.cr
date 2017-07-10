require "./worm/*"

module Worm
  app = App.new
  worm = Worm.new app
  app.run
end
