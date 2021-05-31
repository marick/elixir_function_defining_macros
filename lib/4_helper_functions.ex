defmodule MacroExamples.HelperFunctions do
  
  # Support code for a series of articles on writing macros that expand into
  # definitions of named functions.
  #
  # This one is for https://www.crustofcode.com/def-macro-helper-functions.

  # ---------------------------------------------------------------------

  defmodule BasicIdea do
    @unexpected_value "GUID"

    defp checking_get(key, default) do
      result = Process.get(key, default)
      if result == @unexpected_value,
        do: raise "`#{key}` is not in the process dictionary"
      result
    end

    @doc ~S"""
        iex> import MacroExamples.HelperFunctions.BasicIdea
        iex> Process.put(:required_key, 3)
        iex> required_key()
        3
    """
    def required_key, do: checking_get(:required_key, @unexpected_value)

    @doc ~S"""
        iex> import MacroExamples.HelperFunctions.BasicIdea
        iex> optional_key()
        []
        iex> Process.put(:optional_key, 3)
        iex> optional_key()
        3
    """
    def optional_key, do: checking_get(:optional_key, [])
  end

  # ---------------------------------------------------------------------

  # The following straightforwardly translates the two `*_key` definitions
  # above into a helper function called by two macros. If you uncomment the
  # contents of `BrokenDefinition` below, you'll get:
  #
  #     warning: function checking_get/2 is unused
  #       lib/4_helper_functions.ex:62
  #
  # Let's suppose you ignore that, thinking "it's not used because I haven't
  # made any getters yet" and uncomment the contents of `BrokenUse`. You
  # get more:
  # 
  #     warning: undefined function checking_get/2
  #       lib/4_helper_functions.ex:104
  #
  #     ** (CompileError) lib/4_helper_functions.ex:75: undefined function checking_get/2
  #         (elixir 1.11.2) src/elixir_locals.erl:114: anonymous fn/3 in :elixir_locals.ensure_no_undefined_local/3
  #         lib/4_helper_functions.ex:66: (module)
  #
  # The fix is to make `checking_get` public. However, that works only because
  # `BrokenUse` imports everything. If it imports *only* `getter`, or uses
  # an alias, you're back to the compile error. 
  #
  # The fix is to add `unquote(__MODULE__).` (*not* just `__MODULE__`.) to
  # the call to `checking_get`.

  defmodule BrokenDefinition do
  #   @unexpected_value "GUID"

  #   defp checking_get(key, default) do
  #     result = Process.get(key, default)
  #     if result == @unexpected_value,
  #       do: raise "`#{key}` is not in the process dictionary"
  #     result
  #   end

  #   defp make_def(name_atom, default) do
  #     quote do
  #       def unquote(name_atom)() do
  #         checking_get(unquote(name_atom), unquote(default))
  #       end
  #     end
  #   end

  #   defmacro getter(name_atom) when is_atom(name_atom),
  #     do: make_def(name_atom, @unexpected_value)

  #   defmacro getter([{name_atom, default}]),
  #     do: make_def(name_atom, default)
  end

  defmodule BrokenUse do
  #   import BrokenDefinition, only: [getter: 1]
    
  #   @doc ~S"""
  #       iex> import MacroExamples.HelperFunctions.BrokenUse
  #       iex> Process.put(:required_key, 3)
  #       iex> required_key()
  #       3
  #   """
  #   getter :required_key

  #   @doc ~S"""
  #       iex> import MacroExamples.HelperFunctions.BrokenUse
  #       iex> optional_key()
  #       []
  #       iex> Process.put(:optional_key, 3)
  #       iex> optional_key()
  #       3
        
  #   """
  #   getter optional_key: []
  end

  # ---------------------------------------------------------------------
  
  defmodule WorkingDefinition do
    @unexpected_value "GUID"

    def checking_get(key, default) do
      result = Process.get(key, default)
      if result == @unexpected_value,
        do: raise "`#{key}` is not in the process dictionary"
      result
    end

    defp make_def(name_atom, default) do
      quote do
        def unquote(name_atom)() do
          unquote(__MODULE__).checking_get(unquote(name_atom), unquote(default))
        end
      end
    end

    defmacro getter(name_atom) when is_atom(name_atom),
      do: make_def(name_atom, @unexpected_value)

    defmacro getter([{name_atom, default}]),
      do: make_def(name_atom, default)
  end

  defmodule WorkingUse do
    import WorkingDefinition, only: [getter: 1]
    
    @doc ~S"""
        iex> import MacroExamples.HelperFunctions.WorkingUse
        iex> Process.put(:required_key, 3)
        iex> required_key()
        3
    """
    getter :required_key

    @doc ~S"""
        iex> alias MacroExamples.HelperFunctions.WorkingUse
        iex> WorkingUse.optional_key()
        []
        iex> Process.put(:optional_key, 3)
        iex> WorkingUse.optional_key()
        3
        
    """
    getter optional_key: []
  end
end
