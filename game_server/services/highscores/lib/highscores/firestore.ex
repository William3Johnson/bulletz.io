defmodule Highscores.Firestore do
  @firestore_url "projects/bulletz-io/databases/(default)/documents/highscores/"
  @updateMask %GoogleApi.Firestore.V1.Model.DocumentMask{fieldPaths: ["highscores"]}

  def load_scores(_, nil), do: raise "missing config value: server_name. configure highscores\nconfig :highscores,\n server_name: \"name\""
  def load_scores(conn, server) do
    {:ok, result} = GoogleApi.Firestore.V1.Api.Projects.firestore_projects_databases_documents_get(conn, @firestore_url <> server)
    Map.get(result, :fields) |>
      Map.get("highscores") |>
      Map.get(:arrayValue) |>
      Map.get(:values) |>
      parse_firestore_to_model()
  end

  def sync_scores(conn, server, scores) do
    body = scores |>
      package_to_firestore_types

    {:ok, _response} = GoogleApi.Firestore.V1.Api.Projects.firestore_projects_databases_documents_patch(conn, @firestore_url <> server, updateMask: @updateMask, body: body)
    :ok
  end

  defp package_to_firestore_types(scores) do
    scores = Enum.map(scores, &to_firestore_score/1)
    %{
      fields: %{"highscores" =>
        %GoogleApi.Firestore.V1.Model.Value{
          arrayValue: %GoogleApi.Firestore.V1.Model.ArrayValue{values: scores}
        }
      }
    }
  end

  defp to_firestore_score(%Highscores.Model.Score{name: name, rank: rank, score: score}) do
    %GoogleApi.Firestore.V1.Model.Value{
      mapValue: %GoogleApi.Firestore.V1.Model.MapValue{
        fields: %{
          "name" =>%GoogleApi.Firestore.V1.Model.Value{stringValue: name},
          "score" =>%GoogleApi.Firestore.V1.Model.Value{integerValue: Integer.to_string(score)},
          "rank" =>%GoogleApi.Firestore.V1.Model.Value{integerValue: Integer.to_string(rank)}
        }
      }
    }
  end

  defp parse_firestore_to_model(nil) do
    []
  end
  defp parse_firestore_to_model(highscores) do
    Enum.map(highscores, &parse_score/1)
  end

  defp parse_score(entry) do
    fields = entry |>
      Map.get(:mapValue) |>
      Map.get(:fields)

    name = Map.get(fields, "name") |> Map.get(:stringValue)
    {rank, ""} = Map.get(fields, "rank") |> Map.get(:integerValue) |> Integer.parse()
    {score, ""} = Map.get(fields, "score") |> Map.get(:integerValue) |> Integer.parse()

    %Highscores.Model.Score{rank: rank, name: name, score: score}
  end

end
