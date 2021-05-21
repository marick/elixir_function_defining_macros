defmodule ElixirFunctionDefiningMacrosTest do
  use ExUnit.Case
  doctest ElixirFunctionDefiningMacros

  test "greets the world" do
    assert ElixirFunctionDefiningMacros.hello() == :world
  end
end
