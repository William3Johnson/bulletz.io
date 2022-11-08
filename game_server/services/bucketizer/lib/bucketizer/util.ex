defmodule Bucketizer.Util do
  def bucket_number(x, bucket_size) do
    div(trunc(x), bucket_size)
  end
end
