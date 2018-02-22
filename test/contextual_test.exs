defmodule ContextualTest do
  use ExUnit.Case
  doctest Contextual

  test "greets the world" do
    assert Contextual.hello() == :world
  end
end
