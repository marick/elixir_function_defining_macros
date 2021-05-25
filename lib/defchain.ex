defmodule MacroExamples.Defchain do
  import MacroExamples.Inspect
  defmacro defchain(head, do: body) do
    {_name, _, [return_this | _args]} = head

    IO.inspect head
    IO.inspect return_this
    
    quote do
      def unquote(head) do
        _called_for_side_effect = unquote(body)
        unquote(return_this)
      end
    end
  end
end

defmodule MacroExamples.Defchain.Use do
  import MacroExamples.Defchain
  import MacroExamples.Inspect
  import ExUnit.Assertions

#   pe(__ENV__, quote do: (defchain non_negative(n), do: assert n >= 0))

  @doc ~S"""
      iex> assert_fields(%{a: 3}, a: 3)
      %{a: 3}
  """
  defchain assert_fields(map, pairs) do
    Enum.each(pairs, fn {key, expected} ->
      assert Map.get(map, key) == expected
    end)
  end

  @doc ~S"""
      iex> assert_fields2(%{a: 3}, a: 3)
      %{a: 3}

      iex> assert_fields2(%{a: 3}, [:a])
      %{a: 3}

  """
  defchain assert_fields2(map, key_descriptions) do
    Enum.each(key_descriptions, fn
      {key, expected} ->
        assert Map.get(map, key) == expected
      key ->
        assert Map.has_key?(map, key)
    end)
  end


  # @doc ~S"""
  #     iex> assert_fields3(%{a: 3}, a: 3)
  #     %{a: 3}

  #     iex> assert_fields3(%{a: 3}, [:a])
  #     %{a: 3}

  #     iex> assert_fields3(%{a: 3}, :a)
  #     %{a: 3}

  # """
  # defchain assert_fields3(map, key_descriptions)  do
  #   Enum.each(key_descriptions, fn
  #     {key, expected} ->
  #       assert Map.get(map, key) == expected
  #     key ->
  #       assert Map.has_key?(map, key)
  #   end)
  # end

  # defchain assert_fields(map, one_description) do
  #   assert_fields3(map, [one_description])
  # end


  
end
