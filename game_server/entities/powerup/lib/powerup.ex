defmodule Powerup do

  defstruct [
    :name,
    :effect,
    :sprite,
    frequency: 1,
    priority: 1
  ]

  def new(name, effect, image, frequency) do
    new(name, effect, image,frequency, 1)
  end
  def new(name, effect, image, frequency, priority) do
    %Powerup{
      name: name,
      effect: effect,
      sprite: image,
      frequency: frequency,
      priority: priority
    }
  end

end
