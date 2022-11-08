defmodule FoodBucketizer do
  @bucket_size 150

  def start(_opts, _args) do
    Agent.start_link(fn -> %{} end, name: FoodBucketizer)
  end

  def buckets do
    Agent.get(FoodBucketizer, &(&1))
  end

  def bucket_number(x) do
    div(trunc(x), @bucket_size)
  end

  def clear do
    Agent.update(FoodBucketizer, fn _buckets -> %{} end)
  end

  defp curry_place_food(x_bucket, y_bucket, food) do
    fn buckets ->
      bucket = Map.get(buckets, x_bucket, %{})
      updated_bucket = Map.update(bucket,y_bucket, [food], fn l -> [food | l] end)
      Map.put(buckets, x_bucket, updated_bucket)
    end
  end

  defp curry_remove_food(x_bucket, y_bucket, %{id: id}) do
    fn buckets ->
      bucket = Map.get(buckets, x_bucket, %{})
      updated_bucket = Map.update(bucket, y_bucket, [], fn food_list ->
        Enum.filter(food_list, fn
           %{id: ^id} -> false
           _ -> true
         end)
      end)
      Map.put(buckets, x_bucket, updated_bucket)
    end
  end

  def add_food(food = %{x: x, y: y}) do
    Agent.update(FoodBucketizer, curry_place_food(bucket_number(x), bucket_number(y), food))
  end

  def remove_food(food = %{x: x, y: y}) do
    Agent.update(FoodBucketizer, curry_remove_food(bucket_number(x), bucket_number(y), food))
  end

  def get_bucket(x_bucket, y_bucket) do
    Agent.get(FoodBucketizer, fn buckets -> Map.get(buckets, x_bucket, %{}) |> Map.get(y_bucket, []) end)
  end

  defp inner_get_all_relevant(x, y_range) do
    Enum.map(y_range, fn y ->
      get_bucket(x, y)
    end) |> List.flatten()
  end

  defp get_all_relevant(x_range, y_range) do
    Enum.map(x_range, fn x ->
      inner_get_all_relevant(x, y_range)
    end) |> List.flatten()
  end

  def relevant_buckets(%{x: x, y: y, radius: radius}) do
    x_range = Range.new(bucket_number(x-radius), bucket_number(x+radius))
    y_range = Range.new(bucket_number(y-radius), bucket_number(y+radius))
    get_all_relevant(x_range, y_range)
  end

end
