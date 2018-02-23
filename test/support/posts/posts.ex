defmodule Contextual.Test.Posts do
  use Contextual,
    name: {:post, :posts},
    repo: Contextual.Test.Repo,
    schema: Contextual.Test.Posts.Post
end
