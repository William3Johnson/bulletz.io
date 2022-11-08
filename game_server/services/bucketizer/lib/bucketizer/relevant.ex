defmodule Bucketizer.Relevant do
  import Bucketizer.Util, only: [bucket_number: 2]

  defp alive?(nil), do: false
  defp alive?(pid) do
    Process.alive?(pid)
  end

  def get_bucket(buckets, x_bucket, y_bucket) do
     Map.get(buckets, x_bucket, %{}) |> Map.get(y_bucket, [])
  end

  defp inner_get_all_relevant(buckets, x, y_range) do
    Enum.map(y_range, fn y ->
      get_bucket(buckets, x, y)
    end) |> List.flatten()
  end

  defp get_all_relevant(buckets, x_range, y_range) do
    Enum.map(x_range, fn x ->
      inner_get_all_relevant(buckets, x, y_range)
    end) |> List.flatten()
  end

  def relevant_buckets(buckets, %{x: x, y: y, radius: radius}, bucket_size) do
    x_range = Range.new(bucket_number(x-radius, bucket_size), bucket_number(x+radius, bucket_size))
    y_range = Range.new(bucket_number(y-radius, bucket_size), bucket_number(y+radius, bucket_size))
    get_all_relevant(buckets, x_range, y_range) |>
      Enum.uniq() |> Enum.filter(&alive?/1)
  end

end
