defmodule Contextual.API do
  def list(repo, queryable) do
    repo.all(queryable)
  end

  def get(repo, queryable, id) do
    repo.get(queryable, id)
  end

  def get!(repo, queryable, id) do
    repo.get!(queryable, id)
  end

  def get_by(repo, queryable, opts) do
    repo.get_by(queryable, opts)
  end

  def get_by!(repo, queryable, opts) do
    repo.get_by!(queryable, opts)
  end

  def fetch(repo, queryable, id) do
    case repo.get(queryable, id) do
      nil ->
        :error

      resource ->
        {:ok, resource}
    end
  end

  def fetch_by(repo, queryable, opts) do
    case repo.get_by(queryable, opts) do
      nil ->
        :error

      resource ->
        {:ok, resource}
    end
  end

  def create(repo, schema, attributes) do
    schema
    |> struct()
    |> schema.changeset(attributes)
    |> repo.insert()
  end

  def create!(repo, schema, attributes) do
    schema
    |> struct()
    |> schema.changeset(attributes)
    |> repo.insert!()
  end

  def update(repo, schema, resource, attributes) do
    resource
    |> schema.changeset(attributes)
    |> repo.update()
  end

  def update!(repo, schema, resource, attributes) do
    resource
    |> schema.changeset(attributes)
    |> repo.update!()
  end

  def delete(repo, resource) do
    repo.delete(resource)
  end

  def delete!(repo, resource) do
    repo.delete!(resource)
  end
end
