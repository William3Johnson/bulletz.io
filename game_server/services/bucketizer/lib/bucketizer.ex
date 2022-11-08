defmodule Bucketizer do
  defdelegate update(first, second), to: Bucketizer.Client
  defdelegate relevant_buckets(first, second), to: Bucketizer.Client
end
