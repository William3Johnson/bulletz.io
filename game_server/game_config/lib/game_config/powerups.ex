defmodule GameConfig.Powerups do

  def defaults do
    %{
      min: 0,
      players_per_powerup: 0.75,
      powers: []
    }
  end

  def default_powerups do
    [
      %Powerup{name: "Doge", effect: &Powerup.Doge.doge/1, sprite: "doge.png"},
      %Powerup{name: "Harambe", effect: &Powerup.Harambe.harambe/1, sprite: "harambe.png"},
      %Powerup{name: "Nyan", effect: &Powerup.Nyan.nyan/1, sprite: "nyan.png"},
      %Powerup{name: "Party Parrot", effect: &Powerup.PartyParrot.party_parrot/1, sprite: "party_parrot.png"},
      %Powerup{name: "Ugandan Knuckles", effect: &Powerup.UgandanKnuckles.ugandan_knuckles/1, sprite: "ugandan_knuckles.png"},
    ]
  end

  def halloween do
    [
      %Powerup{ name: "ghost", effect: &Powerup.Ghost.ghost/1, sprite: "ghost.png"},
      %Powerup{ name: "robot", effect: &Powerup.Robot.robot/1, sprite: "robot.png"},
      %Powerup{ name: "spider", effect: &Powerup.Spider.spider/1, sprite: "spider.png"},
      %Powerup{ name: "bat", effect: &Powerup.Bat.bat/1, sprite: "bat.png"}
    ]
  end

  def all do
    [
      %Powerup{name: "Doge", effect: &Powerup.Doge.doge/1, sprite: "doge.png"},
      %Powerup{name: "Harambe", effect: &Powerup.Harambe.harambe/1, sprite: "harambe.png"},
      %Powerup{name: "Nyan", effect: &Powerup.Nyan.nyan/1, sprite: "nyan.png"},
      %Powerup{name: "Party Parrot", effect: &Powerup.PartyParrot.party_parrot/1, sprite: "party_parrot.png"},
      %Powerup{name: "Ugandan Knuckles", effect: &Powerup.UgandanKnuckles.ugandan_knuckles/1, sprite: "ugandan_knuckles.png"},
      %Powerup{ name: "ghost", effect: &Powerup.Ghost.ghost/1, sprite: "ghost.png"},
      %Powerup{ name: "robot", effect: &Powerup.Robot.robot/1, sprite: "robot.png"},
      %Powerup{ name: "spider", effect: &Powerup.Spider.spider/1, sprite: "spider.png"},
      %Powerup{ name: "bat", effect: &Powerup.Bat.bat/1, sprite: "bat.png"}
    ]
  end
end
