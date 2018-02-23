defmodule Contextual.Config do
  @moduledoc """
  Provides utility functions for dealing with configuration options.

  ## Options

      * `:repo` - The `Ecto.Repo` that should be used.
      * `:schema` - The `Ecto.Schema` that should be used.
      * `:name` - A tuple of singular and plural naming for the resource. For example, `{:post, :posts}`.
      * `:name_generator` - A tuple of `{Module, :function}` to generate a name for a given operation.
      * `:only` - A list of operations that should be generated.
      * `:except` - A list of operations that should not be generated.

  """

  def with_defaults(opts) do
    Keyword.put_new(opts, :name_generator, {__MODULE__, :generate_name})
  end

  def enabled?(opts, key) do
    cond do
      opts[:only] ->
        key in opts[:only]

      opts[:except] ->
        key not in opts[:except]

      true ->
        true
    end
  end

  def get_name(opts, key) do
    {mod, fun} = Keyword.fetch!(opts, :name_generator)
    name_config = Keyword.fetch!(opts, :name)

    with :default <- apply(mod, fun, [key, name_config]) do
      generate_name(key, name_config)
    end
  end

  def generate_name(:list, {_, name}), do: :"list_#{name}"
  def generate_name(:get, {name, _}), do: :"get_#{name}"
  def generate_name(:get!, {name, _}), do: :"get_#{name}!"
  def generate_name(:get_by, {name, _}), do: :"get_#{name}_by"
  def generate_name(:get_by!, {name, _}), do: :"get_#{name}_by!"
  def generate_name(:fetch, {name, _}), do: :"fetch_#{name}"
  def generate_name(:fetch_by, {name, _}), do: :"fetch_#{name}_by"
  def generate_name(:change, {name, _}), do: :"change_#{name}"
  def generate_name(:create, {name, _}), do: :"create_#{name}"
  def generate_name(:create!, {name, _}), do: :"create_#{name}!"
  def generate_name(:update, {name, _}), do: :"update_#{name}"
  def generate_name(:update!, {name, _}), do: :"update_#{name}!"
  def generate_name(:delete, {name, _}), do: :"delete_#{name}"
  def generate_name(:delete!, {name, _}), do: :"delete_#{name}!"
end
