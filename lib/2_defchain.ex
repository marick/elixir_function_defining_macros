defmodule MacroExamples.Defchain do
  
  # Support code for a series of articles on writing macros that expand into
  # definitions of named functions.
  #
  # This one is for https://www.crustofcode.com/def-macro-arglist/ and
  # https://www.crustofcode.com/def-macro-guards/.

  # ---------------------------------------------------------------------

  # A macro that expands into a function that returns its first argument.
  # The body is typically an assertion (so its result doesn't matter).
  defmacro defchain(head, do: body) do
    # IO.inspect head
    {_name, _metadata, [return_this | _args]} = head

    quote do
      def unquote(head) do
        _called_for_side_effect = unquote(body)
        unquote(return_this)
      end
    end
  end

  # ---------------------------------------------------------------------

  # This is like plain `defchain`, except that it uses `wrapping:` instead
  # of `do:`.
  defmacro defchain_wrapping(head, wrapping: body) do
    {_name, _, [return_this | _args]} = head
    
    quote do
      def unquote(head) do
        _called_for_side_effect = unquote(body)
        unquote(return_this)
      end
    end
  end

  # ---------------------------------------------------------------------

  # This is a `defchain` that works with guard (`with`) expressions.
  defmacro defchainW(head, do: body) do
    quote do
      def unquote(head) do
        _called_for_side_effect = unquote(body)
        unquote(first_arg_name(head))  # <<< this is the difference
      end
    end
  end

  # A `when...` clause in a def produces a rather peculiar syntax tree.
  # Although it's textually within the `def`, in the tree structure, it's
  # outside it.
  defp first_arg_name(head) do
    case head do
      {:when, _, [true_head | _]} ->
        first_arg_name(true_head)
      _ -> 
        {_name, _, [first_arg_name | _]} = head
        first_arg_name
    end
  end
end

# ---------------------------------------------------------------------

defmodule MacroExamples.Defchain.Use do
  import MacroExamples.Defchain
  import ExUnit.Assertions

  # These are all variations of an assertion that checks certain keys
  # in a given map.

  @doc ~S"""
      iex> map = %{a: 3, b: 4, c: 1}
      iex> map |> assert_fields(a: 3, b: 4) # |> assert...
      %{a: 3, b: 4, c: 1} 
  """
  defchain assert_fields(map, pairs) do
    for {key, expected} <- pairs do 
      assert Map.get(map, key) == expected
    end
  end

  # ---------------------------------------------------------------------

  @doc ~S"""
      iex> assert_fieldsX(%{a: 3}, a: 3)
      %{a: 3}
  """
  defchain_wrapping assert_fieldsX(map, pairs), wrapping:
    (for {key, expected} <- pairs do 
       assert Map.get(map, key) == expected
     end)

  # ---------------------------------------------------------------------

  # An atom without a corresponding value just checks for existence.
  # This illustrates nothing new about macros; it's just a setup for
  # the next example.
  @doc ~S"""
      iex> assert_fields2(%{a: 3}, [:a])
      %{a: 3}

      iex> assert_fields2(%{a: 3}, a: 3)
      %{a: 3}

      iex> assert_fields2(%{a: 3, b: 4}, [:a, b: 4])
      %{a: 3, b: 4}
  """
  defchain assert_fields2(map, key_descriptions) do 
    Enum.each(key_descriptions, fn
      {key, expected} ->
        assert Map.get(map, key) == expected
      key ->
        assert Map.has_key?(map, key)
    end)
  end

  # ---------------------------------------------------------------------

  # The following tries to use `defchain` with a guard. It will produce
  # an `assert_fields3` that contains an infinite recursion. See `inspect.ex`.
  # The doctest is commented out because it triggers the infinite loop.

  # @doc ~S"""
  #     iex> assert_fields3(%{a: 3}, a: 3)  
  #     %{a: 3}
  # """
  defchain assert_fields3(map, about_keys) when is_list(about_keys) do
    Enum.each(about_keys, fn
      {key, expected} ->
        assert Map.get(map, key) == expected
      key ->
        assert Map.has_key?(map, key)
    end)
  end

  defchain assert_fields3(map, one_description) do
    assert_fields3(map, [one_description])
  end

  # ---------------------------------------------------------------------

  # This is a version of `defchain` that works with guards.
  
  defchainW assert_fields4(map, about_keys) when is_list(about_keys) do
    Enum.each(about_keys, fn
      {key, expected} ->
        assert Map.get(map, key) == expected
      key ->
        assert Map.has_key?(map, key)
    end)
  end

  defchainW assert_fields4(map, one_description) do
    assert_fields4(map, [one_description])
  end
end
