defmodule Contextual.Test.Posts.Post do
  use Ecto.Schema

  import Ecto.Changeset

  schema "posts" do
    field(:title, :string)
    timestamps()
  end

  @doc false
  def changeset() do
  end
end
