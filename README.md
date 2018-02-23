# Contextual

`Contextual` generates your [contexts](https://hexdocs.pm/phoenix/contexts.html) for you.

Imagine you have a schema called `MyApp.Posts.Post`. Typically, you'd create a context
to encapsulate `Ecto` access for creating, updating, and deleting posts.

You could use the built-in Phoenix generators to solve this problem, but then you're
left with a bunch of boilerplate code that distracts the reader from the
actual complexity in your contexts.

As an alternative, `Contextual` provides a set of macros to get you up and running.

## Installation

The package can be installed by adding `contextual` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:contextual, "~> 0.1.0"}]
end
```

Documentation can be found at [https://hexdocs.pm/contextual](https://hexdocs.pm/contextual).

## Creating your context

Here's how you'd define your context:

```elixir
defmodule MyApp.Posts do
  use Contextual,
    name: {:post, :posts},
    schema: MyApp.Posts.Post,
    repo: MyApp.Repo
end
```

`MyApp.Posts` now has the following functions:

* `list_posts`
* `get_post`
* `get_post!`
* `get_post_by`
* `get_post_by!`
* `fetch_post`
* `fetch_post_by`
* `create_post`
* `create_post!`
* `update_post`
* `update_post!`
* `delete_post`
* `delete_post!`

## Choosing which functions are generated

All of these functions are overridable. However, if you only wanted to define `get_post`,
you can provide the `:only` option.

```elixir
defmodule MyApp.Posts do
  use Contextual,
    name: {:post, :posts},
    schema: MyApp.Posts.Post,
    repo: MyApp.Repo,
    only: [:get]
end
```

Similarly, `Contextual` provides an `:except` option, which is basically just the opposite of `:only`.

## Don't like the default function names?

Okay, that's fine. You can create your own name generator to solve this problem.

First, create a module that will serve as a name generator:

```elixir
defmodule MyApp.ContextNaming do
  def generate_name(:list, {_singular, plural}) do
    :"all_#{plural}"
  end

  def generate_name(:get, {singular, _plural}) do
    :"find_#{singular}"
  end

  def generate_name(_, _), do: :default
end
```

Next, you'll need to configure your context to use your name generator:

```elixir
defmodule MyApp.Posts do
  use Contextual,
    name: {:post, :posts},
    schema: MyApp.Posts.Post,
    repo: MyApp.Repo,
    name_generator: {MyApp.ContextNaming, :generate_name}
end
```

Now, you'll have `all_posts` instead of `list_posts` and `find_post` instead of `get_post`.

## Contributing

First, you'll need to install the dependencies:

    $ mix deps.get

Next, you'll need to setup the database:

    $ MIX_ENV=test mix do ecto.create, ecto.migrate

Now, you can run the tests:

    $ mix test
