defmodule Contextual.Test.PostsWithOnly do
  use Contextual,
    name: {:post, :posts},
    schema: Contextual.Test.Posts.Post,
    repo: Contextual.Test.Repo,
    only: [:get]
end
