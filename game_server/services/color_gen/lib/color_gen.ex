defmodule ColorGen do

  def color_list do
    GameConfig.get(:color_gen, :colors)
  end

  def start(_opts, _args) do
    Agent.start_link(fn -> MapSet.new end, name: ColorGen)
  end

  def random_color() do
    color_list() |>
      Enum.random()
  end

  def free_color(color) do
    Agent.update(ColorGen, fn state -> MapSet.delete(state, color) end)
  end

  def next_color() do
    state = Agent.get(ColorGen, fn state -> state end)

    color = color_list() |>
      Enum.shuffle() |>
      Enum.find(random_color(), &(!MapSet.member?(state, &1)))

    Agent.update(ColorGen, fn state -> MapSet.put(state, color) end)
    color
  end

end
