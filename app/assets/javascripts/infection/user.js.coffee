window.infection = window.infection || {}

class infection.User
  constructor: (color) ->
    @color = color
    @dim_color = color.replace("rgb", "rgba").replace(")", ", .5)")
    @light_color = @dim_color.replace(/0/g, "128")
    @dark_color = @dim_color.replace(/255/g, "128").replace(/128/g, "64")
