defmodule ContextualTest do
  use ExUnit.Case

  import Ecto.Query

  alias Contextual.Test.Repo
  alias Contextual.Test.Posts.Post

  @all_functions [
    change_post: 0,
    change_post: 1,
    change_post: 2,
    create_post: 0,
    create_post: 1,
    create_post!: 0,
    create_post!: 1,
    delete_post: 1,
    delete_post!: 1,
    fetch_post: 1,
    fetch_post: 2,
    fetch_post_by: 1,
    fetch_post_by: 2,
    get_post: 1,
    get_post: 2,
    get_post!: 1,
    get_post!: 2,
    get_post_by: 1,
    get_post_by: 2,
    get_post_by!: 1,
    get_post_by!: 2,
    list_posts: 0,
    list_posts: 1,
    update_post: 1,
    update_post: 2,
    update_post!: 1,
    update_post!: 2
  ]

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  defp post_fixture(attrs \\ []) do
    attrs = Enum.into(attrs, %{title: "Post"})

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert!()
  end

  describe "defaults" do
    alias Contextual.Test.Posts

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

    test "change/0" do
      assert %Ecto.Changeset{data: %Post{}, changes: %{}} = Posts.change_post()
    end

    test "change/1" do
      post = post_fixture()
      assert %Ecto.Changeset{data: ^post, changes: %{}} = Posts.change_post(post)

      assert %Ecto.Changeset{data: %Post{}, changes: %{title: "Jawn"}} =
               Posts.change_post(%{title: "Jawn"})
    end

    test "change/2" do
      post = post_fixture()

      assert %Ecto.Changeset{data: ^post, changes: %{title: "Jawn"}} =
               Posts.change_post(post, %{title: "Jawn"})
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
      assert Posts.fetch_post(49) == {:error, :not_found}
    end

    test "fetch/2" do
      jawn = post_fixture(title: "Jawn")
      jint = post_fixture(title: "Jint")

      query = from(p in Post, where: p.title == "Jawn")

      assert Posts.fetch_post(query, jawn.id) == {:ok, jawn}
      assert Posts.fetch_post(query, jint.id) == {:error, :not_found}
    end

    test "fetch_by/1" do
      post = post_fixture(title: "Jawn")

      assert Posts.fetch_post_by(title: "Jawn") == {:ok, post}
      assert Posts.fetch_post_by(title: "Jint") == {:error, :not_found}
    end

    test "fetch_by/2" do
      jawn = post_fixture(title: "Jawn")
      jint = post_fixture(title: "Jint")

      query = from(p in Post, where: p.title == "Jawn")

      assert Posts.fetch_post_by(query, id: jawn.id) == {:ok, jawn}
      assert Posts.fetch_post_by(query, id: jint.id) == {:error, :not_found}
    end

    test "update/2" do
      post = post_fixture()

      assert {:ok, %Post{title: "Jint"}} = Posts.update_post(post, %{title: "Jint"})
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, %{title: ""})
    end

    test "update!/2" do
      post = post_fixture()

      assert %Post{title: "Jint"} = Posts.update_post!(post, %{title: "Jint"})

      assert_raise Ecto.InvalidChangesetError, fn ->
        Posts.update_post!(post, %{title: ""})
      end
    end

    test "delete/1" do
      post = post_fixture()

      assert {:ok, %Post{}} = Posts.delete_post(post)
      refute Posts.get_post(post.id)
    end

    test "delete!/1" do
      post = post_fixture()

      assert %Post{} = Posts.delete_post!(post)
      refute Posts.get_post(post.id)
    end

    test "defines all functions" do
      assert Posts.__info__(:functions) == @all_functions
    end
  end

  describe "custom name generation" do
    alias Contextual.Test.PostsWithCustomName, as: Posts

    test "all_posts/1" do
      post_fixture()
      post_fixture()
      assert [%Post{}, %Post{}] = Posts.all_posts()
    end

    test "find_post/1" do
      post = post_fixture()
      assert %Post{} = Posts.find_post(post.id)
      refute Posts.find_post(49)
    end

    test "falls back to the default when the name generator returns :default" do
      assert %Post{} = Posts.create_post!(%{title: "Jawn"})
    end
  end

  describe "only" do
    alias Contextual.Test.PostsWithOnly, as: Posts

    test "only defines the requested functions" do
      assert Posts.__info__(:functions) == [get_post: 1, get_post: 2]
    end
  end

  describe "except" do
    alias Contextual.Test.PostsWithExcept, as: Posts

    test "only defines the requested functions" do
      assert Posts.__info__(:functions) == @all_functions -- [delete_post: 1]
    end
  end
end
