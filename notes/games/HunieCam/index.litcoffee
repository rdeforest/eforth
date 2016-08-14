Doing this over right.

# Usage

$ coffee -r ../$(basename $(pwd))
coffee> start 'example'
coffee> towns
example: 0 girls, 0 fans, 0 dollars, 0 minutes
coffee> hire
avaiable: Tiffany, Nikki, Kyanna
coffee> hire Nikki
coffee> staff
Active: 1 empty slot
Inactive: Nikki
coffee> activate Nikki
coffee>

    libs =
      models: require 'models'
      # more to come obviously

    (require 'bp') libs, (libs) ->
      module.exports = libs
