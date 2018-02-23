defmodule Contextual.Test.PostsWithExcept do
  use Contextual,
    name: {:post, :posts},
    schema: Contextual.Test.Posts.Post,
    repo: Contextual.Test.Repo,
    except: [:delete]
end
