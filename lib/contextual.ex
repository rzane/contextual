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
      @__repo__ Keyword.fetch!(opts, :repo)
      @__schema__ Keyword.fetch!(opts, :schema)

      Contextual.define(opts, :list, fn name ->
        @doc """
        Returns a list of all `#{inspect(@__schema__)}`s.

        ## Examples

            iex> #{name}()
            [%#{inspect(@__schema__)}{}, %#{inspect(@__schema__)}{}, ...]

        """
        def unquote(name)(queryable \\ @__schema__) do
          Contextual.API.list(@__repo__, queryable)
        end
      end)

      Contextual.define(opts, :get, fn name ->
        @doc """
        Gets a single `#{inspect(@__schema__)}`.

        Returns `nil` if the record does not exist.

        ## Examples

            iex> #{name}(19)
            %#{inspect(@__schema__)}{}

            iex> #{name}(42)
            nil

        """
        def unquote(name)(queryable \\ @__schema__, id) do
          Contextual.API.get(@__repo__, queryable, id)
        end
      end)

      Contextual.define(opts, :get!, fn name ->
        @doc """
        Gets a single `#{inspect(@__schema__)}`.

        Raises `Ecto.NoResultsError` if the record does not exist.

        ## Examples

            iex> #{name}(19)
            %#{inspect(@__schema__)}{}

            iex> #{name}(42)
            ** (Ecto.NoResultsError)

        """
        def unquote(name)(queryable \\ @__schema__, id) do
          Contextual.API.get!(@__repo__, queryable, id)
        end
      end)

      Contextual.define(opts, :get_by, fn name ->
        @doc """
        Finds a `#{inspect(@__schema__)}` with the given attributes.

        Returns `nil` if the record is not found.

        ## Examples

            iex> #{name}(title: "Meatloaf")
            %#{inspect(@__schema__)}{}

            iex> #{name}(title: "Baloney")
            nil

        """
        def unquote(name)(queryable \\ @__schema__, clauses) do
          Contextual.API.get_by(@__repo__, queryable, clauses)
        end
      end)

      Contextual.define(opts, :get_by!, fn name ->
        @doc """
        Finds a `#{inspect(@__schema__)}` with the given attributes.

        Returns `nil` if the record is not found.

        ## Examples

            iex> #{name}(title: "Meatloaf")
            %#{inspect(@__schema__)}{}

            iex> #{name}(title: "Baloney")
            ** (Ecto.NoResultsError)

        """
        def unquote(name)(queryable \\ @__schema__, clauses) do
          Contextual.API.get_by!(@__repo__, queryable, clauses)
        end
      end)

      Contextual.define(opts, :fetch, fn name ->
        @doc """
        Gets a single `#{inspect(@__schema__)}`.

        Returns `{:ok, record}` if the record is found.

        Returns `:error` if the record does not exist.

        ## Examples

            iex> #{name}(19)
            {:ok, %#{inspect(@__schema__)}{}}

            iex> #{name}(42)
            :error

        """
        def unquote(name)(queryable \\ @__schema__, id) do
          Contextual.API.fetch(@__repo__, queryable, id)
        end
      end)

      Contextual.define(opts, :fetch_by, fn name ->
        @doc """
        Finds a `#{inspect(@__schema__)}` by the given attributes.

        Returns `{:ok, record}` if the record is found.

        Returns `:error` if the record does not exist.

        ## Examples

            iex> #{name}(title: "Meatloaf")
            {:ok, %#{inspect(@__schema__)}{}}

            iex> #{name}(title: "Baloney")
            :error

        """
        def unquote(name)(queryable \\ @__schema__, clauses) do
          Contextual.API.fetch_by(@__repo__, queryable, clauses)
        end
      end)

      Contextual.define(opts, :create, fn name ->
        @doc """
        Creates a `#{inspect(@__schema__)}`.

        Returns `{:error, changeset}` in the case of failure.

        ## Examples

            iex> #{name}(%{title: "Meatloaf"})
            {:ok, %#{inspect(@__schema__)}{}}

            iex> #{name}(%{title: ""})
            {:error, %Ecto.Changeset{}}

        """
        def unquote(name)(attributes \\ %{}) do
          Contextual.API.create(@__repo__, @__schema__, attributes)
        end
      end)

      Contextual.define(opts, :create!, fn name ->
        @doc """
        Creates a `#{inspect(@__schema__)}`.

        Raises `Ecto.InvalidChangesetError` if the record is invalid.

        ## Examples

            iex> #{name}(%{title: "Meatloaf"})
            %#{inspect(@__schema__)}{}

            iex> #{name}(%{title: ""})
            ** (Ecto.InvalidChangesetError)

        """
        def unquote(name)(attributes \\ %{}) do
          Contextual.API.create!(@__repo__, @__schema__, attributes)
        end
      end)

      Contextual.define(opts, :update, fn name ->
        @doc """
        Updates a `#{inspect(@__schema__)}`.

        Returns `{:error, changeset}` in the case of failure.

        ## Examples

            iex> #{name}(%{title: "Meatloaf"})
            {:ok, %#{inspect(@__schema__)}{}}

            iex> #{name}(%{title: ""})
            {:error, %Ecto.Changeset{}}

        """
        def unquote(name)(resource, attributes \\ %{}) do
          Contextual.API.update(@__repo__, @__schema__, resource, attributes)
        end
      end)

      Contextual.define(opts, :update!, fn name ->
        @doc """
        Updates a `#{inspect(@__schema__)}`.

        Raises `Ecto.InvalidChangesetError` if the record is invalid.

        ## Examples

            iex> #{name}(%{title: "Meatloaf"})
            %#{inspect(@__schema__)}{}

            iex> #{name}(%{title: ""})
            ** (Ecto.InvalidChangesetError)

        """
        def unquote(name)(resource, attributes \\ %{}) do
          Contextual.API.update!(@__repo__, @__schema__, resource, attributes)
        end
      end)

      Contextual.define(opts, :delete, fn name ->
        @doc """
        Deletes a `#{inspect(@__schema__)}`.

        Returns `{:error, changeset}` in the case of failure.

        ## Examples

            iex> #{name}(record)
            {:ok, %#{inspect(@__schema__)}{}}

            iex> #{name}(record)
            {:error, %Ecto.Changeset{}}

        """
        def unquote(name)(resource) do
          Contextual.API.delete(@__repo__, resource)
        end
      end)

      Contextual.define(opts, :delete!, fn name ->
        @doc """
        Deletes a `#{inspect(@__schema__)}`.

        Raises `Ecto.InvalidChangesetError` if the record is invalid.

        ## Examples

            iex> #{name}(record)
            %#{inspect(@__schema__)}{}

            iex> #{name}(record)
            ** (Ecto.InvalidChangesetError)

        """
        def unquote(name)(resource) do
          Contextual.API.delete!(@__repo__, resource)
        end
      end)

      Module.delete_attribute(__MODULE__, :__repo__)
      Module.delete_attribute(__MODULE__, :__schema__)
    end
  end

  @doc false
  defmacro define(opts, key, fun) do
    quote bind_quoted: [opts: opts, key: key, fun: fun] do
      if Contextual.enabled?(opts, key) do
        fun.(Contextual.get_name(opts, key))
        defoverridable Contextual.get_specs(opts, key)
      end
    end
  end

  @doc false
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
