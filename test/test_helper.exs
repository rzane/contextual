{:ok, _} = Contextual.Test.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Contextual.Test.Repo, :manual)
ExUnit.start()
