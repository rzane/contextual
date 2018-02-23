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
    actions = build_actions(opts)
    schema = Keyword.fetch!(opts, :schema)
    repo = Keyword.fetch!(opts, :repo)

    quote location: :keep, bind_quoted: [actions: actions, schema: schema, repo: repo] do
      @repo repo
      @schema schema

      Contextual.define(actions, :list, fn name ->
        def unquote(name)(queryable \\ @schema) do
          Contextual.API.list(@repo, queryable)
        end
      end)

      Contextual.define(actions, :get, fn name ->
        def unquote(name)(queryable \\ @schema, id) do
          Contextual.API.get(@repo, queryable, id)
        end
      end)

      Contextual.define(actions, :get!, fn name ->
        def unquote(name)(queryable \\ @schema, id) do
          Contextual.API.get!(@repo, queryable, id)
        end
      end)

      Contextual.define(actions, :get_by, fn name ->
        def unquote(name)(queryable \\ @schema, opts) do
          Contextual.API.get_by(@repo, queryable, opts)
        end
      end)

      Contextual.define(actions, :get_by!, fn name ->
        def unquote(name)(queryable \\ @schema, opts) do
          Contextual.API.get_by!(@repo, queryable, opts)
        end
      end)

      Contextual.define(actions, :fetch, fn name ->
        def unquote(name)(queryable \\ @schema, id) do
          Contextual.API.fetch(@repo, queryable, id)
        end
      end)

      Contextual.define(actions, :fetch_by, fn name ->
        def unquote(name)(queryable \\ @schema, opts) do
          Contextual.API.fetch_by(@repo, queryable, opts)
        end
      end)

      Contextual.define(actions, :create, fn name ->
        def unquote(name)(attributes \\ %{}) do
          Contextual.API.create(@repo, @schema, attributes)
        end
      end)

      Contextual.define(actions, :create!, fn name ->
        def unquote(name)(attributes \\ %{}) do
          Contextual.API.create!(@repo, @schema, attributes)
        end
      end)

      Contextual.define(actions, :update, fn name ->
        def unquote(name)(resource, attributes \\ %{}) do
          Contextual.API.update(@repo, @schema, resource, attributes)
        end
      end)

      Contextual.define(actions, :update!, fn name ->
        def unquote(name)(resource, attributes \\ %{}) do
          Contextual.API.update!(@repo, @schema, resource, attributes)
        end
      end)

      Contextual.define(actions, :delete, fn name ->
        def unquote(name)(resource) do
          Contextual.API.delete(@repo, resource)
        end
      end)

      Contextual.define(actions, :delete!, fn name ->
        def unquote(name)(resource) do
          Contextual.API.delete!(@repo, resource)
        end
      end)
    end
  end

  defp build_actions(opts) do
    name = Keyword.fetch!(opts, :name)

    Enum.map(@operations, fn {op, arity} ->
      name = name_for(op, name)
      fns = Enum.map(arity, &{name, &1})
      {op, [name: name, fns: fns]}
    end)
  end

  defmacro define(actions, key, fun) do
    quote bind_quoted: [actions: actions, key: key, fun: fun] do
      if Keyword.has_key?(actions, key) do
        fun.(actions[key][:name])
        defoverridable actions[key][:fns]
      end
    end
  end

  defp name_for(:list, {_, name}), do: :"list_#{name}"
  defp name_for(:get, {name, _}), do: :"get_#{name}"
  defp name_for(:get!, {name, _}), do: :"get_#{name}!"
  defp name_for(:get_by, {name, _}), do: :"get_#{name}_by"
  defp name_for(:get_by!, {name, _}), do: :"get_#{name}_by!"
  defp name_for(:fetch, {name, _}), do: :"fetch_#{name}"
  defp name_for(:fetch_by, {name, _}), do: :"fetch_#{name}_by"
  defp name_for(:create, {name, _}), do: :"create_#{name}"
  defp name_for(:create!, {name, _}), do: :"create_#{name}!"
  defp name_for(:update, {name, _}), do: :"update_#{name}"
  defp name_for(:update!, {name, _}), do: :"update_#{name}!"
  defp name_for(:delete, {name, _}), do: :"delete_#{name}"
  defp name_for(:delete!, {name, _}), do: :"delete_#{name}!"
end
