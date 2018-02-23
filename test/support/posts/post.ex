defmodule Contextual.Test.Posts.Post do
  use Ecto.Schema

  import Ecto.Changeset

  alias Contextual.Test.Posts.Post

  @type t :: %__MODULE__{}

  schema "posts" do
    field(:title, :string)
    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attributes) do
    post
    |> cast(attributes, [:title])
    |> validate_required([:title])
  end
end
