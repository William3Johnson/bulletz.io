defmodule Bucketizer.Update do
  import Bucketizer.Util, only: [bucket_number: 2]

  defp find_buckets({pid, %{x: x, y: y, radius: radius}}, bucket_size) do
    x_range = Range.new(bucket_number(x-radius, bucket_size), bucket_number(x+radius, bucket_size))
    y_range = Range.new(bucket_number(y-radius, bucket_size), bucket_number(y+radius, bucket_size))
    for x <- x_range, y <- y_range, do: {x, y, pid}
  end

  def place_entity(buckets, x_bucket, y_bucket, entity) do
    bucket = Map.get(buckets, x_bucket, %{})
    updated_bucket = Map.update(bucket, y_bucket, [entity], fn l -> [entity | l] end)
    Map.put(buckets, x_bucket, updated_bucket)
  end

  def calculate_buckets(entities) do
    bucket_size = 150 #TODO calc using math
    entities |>
      Enum.map(fn e -> find_buckets(e, bucket_size) end) |>
      List.flatten() |>
      Enum.reduce(%{}, fn {x_bucket, y_bucket, pid}, buckets ->
        place_entity(buckets, x_bucket, y_bucket, pid)
      end) |> place_bucket_size(bucket_size)
  end

  defp place_bucket_size(arg, bucket_size) do
    {arg, bucket_size}
  end

end
