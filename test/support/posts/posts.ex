defmodule Contextual.Test.Posts do
  use Contextual,
    name: {:post, :posts},
    schema: Contextual.Test.Posts.Post,
    repo: Contextual.Test.Repo
end
