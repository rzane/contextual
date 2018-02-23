defmodule Contextual.Test.NameGenerator do
  def generate_name(:list, {_singular, _plural}) do
    :catch_em_all
  end

  def generate_name(_, _), do: :default
end

defmodule Contextual.Test.PostsWithCustomName do
  use Contextual,
    name: {:post, :posts},
    schema: Contextual.Test.Posts.Post,
    repo: Contextual.Test.Repo,
    name_generator: {Contextual.Test.NameGenerator, :generate_name}
end
