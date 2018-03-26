defmodule Contextual do
  defmacro __using__(opts) do
    opts = Contextual.Config.with_defaults(opts)

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
        @spec unquote(name)(Ecto.Queryable.t()) :: [unquote(@__schema__).t()]
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
        @spec unquote(name)(Ecto.Queryable.t(), term) :: unquote(@__schema__).t() | nil
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
        @spec unquote(name)(Ecto.Queryable.t(), term) :: unquote(@__schema__).t() | no_return
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
        @spec unquote(name)(Ecto.Queryable.t(), list()) :: unquote(@__schema__).t() | nil
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
        @spec unquote(name)(Ecto.Queryable.t(), list()) :: unquote(@__schema__).t() | no_return()
        def unquote(name)(queryable \\ @__schema__, clauses) do
          Contextual.API.get_by!(@__repo__, queryable, clauses)
        end
      end)

      Contextual.define(opts, :fetch, fn name ->
        @doc """
        Gets a single `#{inspect(@__schema__)}`.

        Returns `{:ok, record}` if the record is found.

        Returns `{:error, :not_found}` if the record does not exist.

        ## Examples

            iex> #{name}(19)
            {:ok, %#{inspect(@__schema__)}{}}

            iex> #{name}(42)
            {:error, :not_found}

        """
        @spec unquote(name)(Ecto.Queryable.t(), term) ::
                {:ok, unquote(@__schema__).t()} | {:error, :not_found}
        def unquote(name)(queryable \\ @__schema__, id) do
          Contextual.API.fetch(@__repo__, queryable, id)
        end
      end)

      Contextual.define(opts, :fetch_by, fn name ->
        @doc """
        Finds a `#{inspect(@__schema__)}` by the given attributes.

        Returns `{:ok, record}` if the record is found.

        Returns `{:error, :not_found}` if the record does not exist.

        ## Examples

            iex> #{name}(title: "Meatloaf")
            {:ok, %#{inspect(@__schema__)}{}}

            iex> #{name}(title: "Baloney")
            {:error, :not_found}

        """
        @spec unquote(name)(Ecto.Queryable.t(), list()) ::
                {:ok, unquote(@__schema__).t()} | {:error, :not_found}
        def unquote(name)(queryable \\ @__schema__, clauses) do
          Contextual.API.fetch_by(@__repo__, queryable, clauses)
        end
      end)

      Contextual.define(opts, :change, fn name ->
        @doc """
        See the documentation for `#{name}/2`.
        """
        @spec unquote(name)() :: Ecto.Changeset.t()
        def unquote(name)() do
          Contextual.API.change(@__schema__, struct(@__schema__), %{})
        end

        @doc """
        See the documentation for `#{name}/2`.
        """
        @spec unquote(name)(unquote(@__schema__).t() | map) :: Ecto.Changeset.t()
        def unquote(name)(%@__schema__{} = resource_or_attributes) do
          Contextual.API.change(@__schema__, resource_or_attributes, %{})
        end

        def unquote(name)(resource_or_attributes) when is_map(resource_or_attributes) do
          Contextual.API.change(@__schema__, struct(@__schema__), resource_or_attributes)
        end

        @doc """
        Create an `Ecto.Changeset` for a `#{inspect(@__schema__)}`.

        ## Examples

            iex> #{name}()
            %Ecto.Changeset{data: %#{inspect(@__schema__)}{}, changes: %{}}

            iex> #{name}(%{title: "Meatloaf"})
            %Ecto.Changeset{data: %#{inspect(@__schema__)}{}, changes: %{title: "Meatloaf"}}

            iex> #{name}(%#{inspect(@__schema__)}{title: "Lobster"})
            %Ecto.Changeset{data: %#{inspect(@__schema__)}{title: "Lobster"}, changes: %{}}

            iex> #{name}(%#{inspect(@__schema__)}{title: "Lobster"}, %{title: "Meatloaf"})
            %Ecto.Changeset{data: %#{inspect(@__schema__)}{title: "Lobster"}, changes: %{title: "Meatloaf"}}

        """
        @spec unquote(name)(unquote(@__schema__).t(), map) :: Ecto.Changeset.t()
        def unquote(name)(%__schema__{} = resource, attributes) when is_map(attributes) do
          Contextual.API.change(@__schema__, resource, attributes)
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
        @spec unquote(name)(map) :: {:ok, unquote(@__schema__).t()} | {:error, Ecto.Changeset.t()}
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
        @spec unquote(name)(map) :: unquote(@__schema__).t() | no_return
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
        @spec unquote(name)(unquote(@__schema__).t(), map) ::
                {:ok, unquote(@__schema__).t()} | {:error, Ecto.Changeset.t()}
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
        @spec unquote(name)(unquote(@__schema__).t(), map) :: unquote(@__schema__).t() | no_return
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
        @spec unquote(name)(unquote(@__schema__).t()) ::
                {:ok, unquote(@__schema__).t()} | {:error, Ecto.Changeset.t()}
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
        @spec unquote(name)(unquote(@__schema__).t()) :: unquote(@__schema__).t() | no_return
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
      if Contextual.Config.enabled?(opts, key) do
        fun.(Contextual.Config.get_name(opts, key))
      end
    end
  end
end
