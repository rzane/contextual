defmodule Contextual do
  defmacro __using__(opts) do
    {singular, plural} = Keyword.fetch!(opts, :name)
    schema = Keyword.fetch!(opts, :schema)
    repo = Keyword.fetch!(opts, :repo)

    quote location: :keep do
      @repo unquote(repo)
      @schema unquote(schema)

      def unquote(:"list_#{plural}")(queryable \\ @schema) do
        Contextual.API.list(@repo, queryable)
      end

      def unquote(:"get_#{singular}")(queryable \\ @schema, id) do
        Contextual.API.get(@repo, queryable, id)
      end

      def unquote(:"get_#{singular}!")(queryable \\ @schema, id) do
        Contextual.API.get!(@repo, queryable, id)
      end

      def unquote(:"get_#{singular}_by")(queryable \\ @schema, opts) do
        Contextual.API.get_by(@repo, queryable, opts)
      end

      def unquote(:"get_#{singular}_by!")(queryable \\ @schema, opts) do
        Contextual.API.get_by!(@repo, queryable, opts)
      end

      def unquote(:"fetch_#{singular}")(queryable \\ @schema, id) do
        Contextual.API.fetch(@repo, queryable, id)
      end

      def unquote(:"fetch_#{singular}_by")(queryable \\ @schema, opts) do
        Contextual.API.fetch_by(@repo, queryable, opts)
      end

      def unquote(:"create_#{singular}")(attributes \\ %{}) do
        Contextual.API.create(@repo, @schema, attributes)
      end

      def unquote(:"create_#{singular}!")(attributes \\ %{}) do
        Contextual.API.create!(@repo, @schema, attributes)
      end

      def unquote(:"update_#{singular}")(resource, attributes \\ %{}) do
        Contextual.API.update(@repo, @schema, resource, attributes)
      end

      def unquote(:"update_#{singular}!")(resource, attributes \\ %{}) do
        Contextual.API.update!(@repo, @schema, resource, attributes)
      end

      def unquote(:"delete_#{singular}")(resource) do
        Contextual.API.delete(@repo, resource)
      end

      def unquote(:"delete_#{singular}!")(resource) do
        Contextual.API.delete!(@repo, resource)
      end
    end
  end
end
