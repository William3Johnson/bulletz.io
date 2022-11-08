defmodule Highscores.Auth do
  @scope "https://www.googleapis.com/auth/datastore"
  def token() do
    {:ok, token} = Goth.Token.for_scope(@scope)
    token.token
  end

  def conn() do
    GoogleApi.Firestore.V1.Connection.new(token())
  end
end
