defmodule Contextual do
  @operations [
    list: [0, 1],
    get: [1, 2],
    get!: [1, 2],
    get_by: [1, 2],
    get_by!: [1, 2],
    fetch: [1, 2],
    fetch_by: [1, 2],
    create: [0, 1],
    create!: [0, 1],
    update: [1, 2],
    update!: [1, 2],
    delete: [1],
    delete!: [1]
  ]

  defmacro __using__(opts) do
    opts = Keyword.put_new(opts, :name_generator, {__MODULE__, :generate_name})

    quote location: :keep, bind_quoted: [opts: opts] do
      @repo Keyword.fetch!(opts, :repo)
      @schema Keyword.fetch!(opts, :schema)

      Contextual.define(opts, :list, fn name ->
        def unquote(name)(queryable \\ @schema) do
          Contextual.API.list(@repo, queryable)
        end
      end)

      Contextual.define(opts, :get, fn name ->
        def unquote(name)(queryable \\ @schema, id) do
          Contextual.API.get(@repo, queryable, id)
        end
      end)

      Contextual.define(opts, :get!, fn name ->
        def unquote(name)(queryable \\ @schema, id) do
          Contextual.API.get!(@repo, queryable, id)
        end
      end)

      Contextual.define(opts, :get_by, fn name ->
        def unquote(name)(queryable \\ @schema, opts) do
          Contextual.API.get_by(@repo, queryable, opts)
        end
      end)

      Contextual.define(opts, :get_by!, fn name ->
        def unquote(name)(queryable \\ @schema, opts) do
          Contextual.API.get_by!(@repo, queryable, opts)
        end
      end)

      Contextual.define(opts, :fetch, fn name ->
        def unquote(name)(queryable \\ @schema, id) do
          Contextual.API.fetch(@repo, queryable, id)
        end
      end)

      Contextual.define(opts, :fetch_by, fn name ->
        def unquote(name)(queryable \\ @schema, opts) do
          Contextual.API.fetch_by(@repo, queryable, opts)
        end
      end)

      Contextual.define(opts, :create, fn name ->
        def unquote(name)(attributes \\ %{}) do
          Contextual.API.create(@repo, @schema, attributes)
        end
      end)

      Contextual.define(opts, :create!, fn name ->
        def unquote(name)(attributes \\ %{}) do
          Contextual.API.create!(@repo, @schema, attributes)
        end
      end)

      Contextual.define(opts, :update, fn name ->
        def unquote(name)(resource, attributes \\ %{}) do
          Contextual.API.update(@repo, @schema, resource, attributes)
        end
      end)

      Contextual.define(opts, :update!, fn name ->
        def unquote(name)(resource, attributes \\ %{}) do
          Contextual.API.update!(@repo, @schema, resource, attributes)
        end
      end)

      Contextual.define(opts, :delete, fn name ->
        def unquote(name)(resource) do
          Contextual.API.delete(@repo, resource)
        end
      end)

      Contextual.define(opts, :delete!, fn name ->
        def unquote(name)(resource) do
          Contextual.API.delete!(@repo, resource)
        end
      end)
    end
  end

  defmacro define(opts, key, fun) do
    quote bind_quoted: [opts: opts, key: key, fun: fun] do
      if Contextual.enabled?(opts, key) do
        fun.(Contextual.get_name(opts, key))
        defoverridable Contextual.get_specs(opts, key)
      end
    end
  end

  @doc false
  def enabled?(_opts, _key) do
    true
  end

  @doc false
  def get_name(opts, key) do
    {mod, fun} = Keyword.fetch!(opts, :name_generator)
    name_config = Keyword.fetch!(opts, :name)

    with :default <- apply(mod, fun, [key, name_config]) do
      generate_name(key, name_config)
    end
  end

  @doc false
  def get_specs(opts, key) do
    name = get_name(opts, key)

    @operations
    |> Keyword.fetch!(key)
    |> Enum.map(&{name, &1})
  end

  @doc false
  def generate_name(:list, {_, name}), do: :"list_#{name}"
  def generate_name(:get, {name, _}), do: :"get_#{name}"
  def generate_name(:get!, {name, _}), do: :"get_#{name}!"
  def generate_name(:get_by, {name, _}), do: :"get_#{name}_by"
  def generate_name(:get_by!, {name, _}), do: :"get_#{name}_by!"
  def generate_name(:fetch, {name, _}), do: :"fetch_#{name}"
  def generate_name(:fetch_by, {name, _}), do: :"fetch_#{name}_by"
  def generate_name(:create, {name, _}), do: :"create_#{name}"
  def generate_name(:create!, {name, _}), do: :"create_#{name}!"
  def generate_name(:update, {name, _}), do: :"update_#{name}"
  def generate_name(:update!, {name, _}), do: :"update_#{name}!"
  def generate_name(:delete, {name, _}), do: :"delete_#{name}"
  def generate_name(:delete!, {name, _}), do: :"delete_#{name}!"
end
