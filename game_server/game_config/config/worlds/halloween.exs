use Mix.Config

config :world,
  background: "#00000088",
  background_boundary: "#FE8000",
  background_image: "/images/backgrounds/halloween.jpg",
  grid_color: "#EB612377"

config :powerups,
  powers: :halloween

config :color_gen,
  colors: ["#EB6123", "#EFBD76", "#FE8000", "#FFA52B", "#EEEA4D", "#EB5B0C", "#FFB64B", "#E9A600"]

config :food,
  radius: 10,
  base_food: 10,
  lifetime: 8000

config :bullet,
  parent_radius_ratio: 6.5,
  global_damage_mod: 1

config :highscores,
  server_name: "halloween",
  max_scores: 10

config :bot,
 minimum_bots: 5,
 max_bots: 8
