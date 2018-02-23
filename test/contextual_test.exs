defmodule ContextualTest do
  use ExUnit.Case

  import Ecto.Query

  alias Contextual.Test.Repo
  alias Contextual.Test.Posts
  alias Contextual.Test.Posts.Post

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  defp post_fixture(attrs \\ []) do
    attrs = Enum.into(attrs, %{title: "Post"})

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert!()
  end

  test "create/1" do
    assert {:ok, %Post{title: "Jawn"}} = Posts.create_post(%{title: "Jawn"})
    assert {:error, %Ecto.Changeset{}} = Posts.create_post(%{title: ""})
  end

  test "create!/1" do
    assert %Post{title: "Jawn"} = Posts.create_post!(%{title: "Jawn"})

    assert_raise Ecto.InvalidChangesetError, fn ->
      Posts.create_post!(%{title: ""})
    end
  end

  test "list/0" do
    jawn = post_fixture(title: "Jawn")
    jint = post_fixture(title: "Jint")
    assert Posts.list_posts() == [jawn, jint]
  end

  test "list/1" do
    post_fixture(title: "Jawn")
    jint = post_fixture(title: "Jint")

    query = from(p in Post, where: p.title == "Jint")
    assert Posts.list_posts(query) == [jint]
  end

  test "get/1" do
    post = post_fixture()
    assert Posts.get_post(post.id) == post
    refute Posts.get_post(49)
  end

  test "get/2" do
    post = post_fixture(title: "Jawn")
    query = from(p in Post, where: p.title == "Jawn")

    assert Posts.get_post(query, post.id) == post
    refute Posts.get_post(query, 49)
  end

  test "get!/1" do
    post = post_fixture()
    assert Posts.get_post!(post.id) == post
    assert_raise Ecto.NoResultsError, fn ->
      Posts.get_post!(49)
    end
  end

  test "get!/2" do
    post = post_fixture(title: "Jawn")
    query = from(p in Post, where: p.title == "Jawn")

    assert Posts.get_post!(query, post.id) == post
    assert_raise Ecto.NoResultsError, fn ->
      Posts.get_post!(query, 49)
    end
  end

  test "get_by/1" do
    post = post_fixture(title: "Jawn")

    assert Posts.get_post_by(title: "Jawn") == post
    refute Posts.get_post_by(title: "Jint")
  end

  test "get_by/2" do
    jawn = post_fixture(title: "Jawn")
    jint = post_fixture(title: "Jint")

    query = from(p in Post, where: p.title == "Jawn")

    assert Posts.get_post_by(query, id: jawn.id) == jawn
    refute Posts.get_post_by(query, id: jint.id)
  end

  test "get_by!/1" do
    jawn = post_fixture(title: "Jawn")

    assert Posts.get_post_by!(title: "Jawn") == jawn

    assert_raise Ecto.NoResultsError, fn ->
      Posts.get_post_by!(title: "Jint")
    end
  end

  test "get_by!/2" do
    jawn = post_fixture(title: "Jawn")
    jint = post_fixture(title: "Jint")

    query = from(p in Post, where: p.title == "Jawn")

    assert Posts.get_post_by!(query, id: jawn.id) == jawn

    assert_raise Ecto.NoResultsError, fn ->
      Posts.get_post_by!(query, id: jint.id)
    end
  end

  test "fetch/1" do
    post = post_fixture(title: "Jawn")
    assert Posts.fetch_post(post.id) == {:ok, post}
    assert Posts.fetch_post(49) == :error
  end

  test "fetch/2" do
    jawn = post_fixture(title: "Jawn")
    jint = post_fixture(title: "Jint")

    query = from(p in Post, where: p.title == "Jawn")

    assert Posts.fetch_post(query, jawn.id) == {:ok, jawn}
    assert Posts.fetch_post(query, jint.id) == :error
  end

  test "fetch_by/1" do
    post = post_fixture(title: "Jawn")

    assert Posts.fetch_post_by(title: "Jawn") == {:ok, post}
    assert Posts.fetch_post_by(title: "Jint") == :error
  end

  test "fetch_by/2" do
    jawn = post_fixture(title: "Jawn")
    jint = post_fixture(title: "Jint")

    query = from(p in Post, where: p.title == "Jawn")

    assert Posts.fetch_post_by(query, id: jawn.id) == {:ok, jawn}
    assert Posts.fetch_post_by(query, id: jint.id) == :error
  end

  test "update" do
    post = post_fixture()

    assert {:ok, %Post{title: "Jint"}} = Posts.update_post(post, %{title: "Jint"})
    assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, %{title: ""})
  end

  test "update!" do
    post = post_fixture()

    assert %Post{title: "Jint"} = Posts.update_post!(post, %{title: "Jint"})
    assert_raise Ecto.InvalidChangesetError, fn ->
      Posts.update_post!(post, %{title: ""})
    end
  end

  test "delete" do
    post = post_fixture()

    assert {:ok, %Post{}} = Posts.delete_post(post)
    refute Posts.get_post(post.id)
  end

  test "delete!" do
    post = post_fixture()

    assert %Post{} = Posts.delete_post!(post)
    refute Posts.get_post(post.id)
  end
end
