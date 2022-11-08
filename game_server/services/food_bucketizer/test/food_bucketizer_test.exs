defmodule FoodBucketizerTest do
  use ExUnit.Case, async: false
  doctest FoodBucketizer

  import FoodBucketizer

  test "add food adds a food to the bucket agent" do
    FoodBucketizer.clear()
    food = %{x: 0, y: 0}
    FoodBucketizer.add_food(food)
    [%{x: 0, y: 0}] = get_bucket(0, 0)
  end

  test "add multiple food to one bucket" do
    FoodBucketizer.clear()
    food = %{x: 0, y: 0}
    FoodBucketizer.add_food(food)
    FoodBucketizer.add_food(food)
    food_bucket = get_bucket(0, 0)
    assert length(food_bucket) == 2
  end

  test "food can be removed from buckets" do
    FoodBucketizer.clear()
    food = %{x: 0, y: 0, id: :test_food}
    FoodBucketizer.add_food(food)
    [%{x: 0, y: 0, id: :test_food}] = get_bucket(0, 0)
    FoodBucketizer.remove_food(food)
    [] = get_bucket(0, 0)
  end

end
