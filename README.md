# Contextual [![Build Status](https://travis-ci.org/rzane/contextual.svg?branch=master)](https://travis-ci.org/rzane/contextual)

`Contextual` provides a macro that will generate your Ecto [contexts](https://hexdocs.pm/phoenix/contexts.html) for you.

Imagine you have a schema called `MyApp.Posts.Post`. Typically, you'd create a context
to encapsulate `Ecto` access for creating, updating, and deleting posts.

You could use the built-in Phoenix generators to solve this problem, but then you're
left with a bunch of boilerplate code that distracts the reader from the
actual complexity in your contexts.

Instead, `use Contextual` and delete a bunch of boilerplate code. Or not, it's entirely your decision.

## Installation

The package can be installed by adding `contextual` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:contextual, "~> 1.0.0"}]
end
```

Documentation can be found at [https://hexdocs.pm/contextual](https://hexdocs.pm/contextual).

## Usage

Contextual requires three options:

* `:name` - A tuple of `{:singular, :plural}` naming for your resource.
* `:schema` - An `Ecto.Schema`
* `:repo` - An `Ecto.Repo`

Here's what your context might look like:

```elixir
defmodule MyApp.Posts do
  use Contextual,
    name: {:post, :posts},
    schema: MyApp.Posts.Post,
    repo: MyApp.Repo
end
```

`MyApp.Posts` now has the following functions:

```elixir
alias MyApp.Posts
alias MyApp.Posts.Post

import Ecto.Query

# List a collection
posts = Posts.list_posts()
posts = Posts.list_posts(from(p in Post, where: p.title == "Meatloaf"))

# Get a record by ID
post = Posts.get_post(19)
post = Posts.get_post!(19)
{:ok, post} = Posts.fetch_post(19)

# Get a record by attributes
post = Posts.get_post_by(title: "Meatloaf")
post = Posts.get_post_by!(title: "Meatloaf")
{:ok, post} = Posts.fetch_post_by(title: "Meatloaf")

# Create a changeset for a given post
changeset = Posts.change_post()
changeset = Posts.change_post(post)
changeset = Posts.change_post(%{title: "Meatloaf"})
changeset = Posts.change_post(post, %{title: "Meatloaf"})

# Create a post
{:ok, post} = Posts.create_post(%{title: "Meatloaf"})
post = Posts.create_post!(%{title: "Meatloaf"})

# Update a post
{:ok, post} = Posts.update_post(post, %{title: "Meatloaf"})
post = Posts.update_post!(post, %{title: "Meatloaf"})

# Delete a post
{:ok, post} = Posts.delete_post(post)
post = Posts.delete_post!(post)
```

### Choosing which functions are generated

That seems reasonable. If you only wanted to define `get_post`, you can provide the `:only` option.

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

### Customizing function names

Contextual allows you to choose how your functions are named by using a name generator.

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

The `generate_name/2` function must return an atom. If the function returns `:default`, Contextual will
fallback to the default naming convention.

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

### Typespecs

Contextual will automatically generate documentation and typespecs for thefunctions
that it defines. However, it expects your schema to have a type `t` defined.

To get the typespecs working properly, you'll need to define that type on your schema:

```elixir
defmodule MyApp.Posts.Post do
  # ...
  @type t :: %__MODULE__{}
end
```

## Contributing

The tests run against PostgreSQL. The `test` command will setup a test database for you.

To run the tests, just run:

    $ mix test
