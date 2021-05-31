defmodule MacroExamples.Getters do
  
  # Support code for a series of articles on writing macros that expand into
  # definitions of named functions.
  #
  # This one is for https://www.crustofcode.com/def-macro-getter.

  # ---------------------------------------------------------------------


  defmodule Manual do
    @doc ~S"""
        iex> Process.put(:required_key, 3)
        iex> alias MacroExamples.Getters.Manual
        iex> Manual.required_key
        3
    """
    def required_key, do: Process.get(:required_key)
    
    @doc ~S"""
        iex> alias MacroExamples.Getters.Manual
        iex> Manual.optional_key
        []
        iex> Process.put(:optional_key, 3)
        iex> Manual.optional_key
        3
    """
    def optional_key, do: Process.get(:optional_key, [])
  end

  # ---------------------------------------------------------------------

  defmodule ByName do
    defmacro getter(name) do
      {name_atom, _, _} = name
      quote do
        def unquote(name), do: Process.get(unquote(name_atom))
      end
    end

    defmacro getter(name, default_ast) do
      {name_atom, _, _} = name
      quote do
        def unquote(name), do: Process.get(unquote(name_atom), unquote(default_ast))
      end
    end
  end
  
  defmodule UseByName do
    import ByName
    @doc ~S"""
        iex> Process.put(:required_key, 3)
        iex> alias MacroExamples.Getters.UseByName
        iex> UseByName.required_key
        3
    """
    getter required_key

    @doc ~S"""
        iex> alias MacroExamples.Getters.UseByName
        iex> UseByName.optional_key
        []
        iex> Process.put(:optional_key, 3)
        iex> UseByName.optional_key
        3
    """
    getter optional_key, []
  end

  # ---------------------------------------------------------------------

  defmodule ByAtom do
    defmacro getter(name_atom) when is_atom(name_atom) do
      name = {name_atom, [], nil}
      quote do
        def unquote(name), do: Process.get(unquote(name_atom))
      end
    end

    defmacro getter([{name_atom, default_ast}]) do
      name = {name_atom, [], nil}
      quote do
        def unquote(name), do: Process.get(unquote(name_atom), unquote(default_ast))
      end
    end
  end
  
  defmodule UseByAtom do
    import ByAtom
    @doc ~S"""
        iex> alias MacroExamples.Getters.UseByAtom
        iex> Process.put(:required_key, 3)
        iex> UseByAtom.required_key
        3
    """
    getter :required_key

    @doc ~S"""
        iex> alias MacroExamples.Getters.UseByAtom
        iex> UseByAtom.optional_key
        %{a: 3}
        iex> Process.put(:optional_key, 3)
        iex> UseByAtom.optional_key
        3
        
    """
    getter optional_key: %{a: 3}
  end

  # ---------------------------------------------------------------------

  defmodule ByAtomBetter do
    defmacro getter(name_atom) when is_atom(name_atom) do
      quote do
        def unquote(name_atom)(), do: Process.get(unquote(name_atom))
      end
    end

    defmacro getter([{name_atom, default_ast}]) do
      quote do
        def unquote(name_atom)(),
          do: Process.get(unquote(name_atom), unquote(default_ast))
      end
    end
  end
  
  defmodule UseByAtomBetter do
    import ByAtomBetter
    @doc ~S"""
        iex> alias MacroExamples.Getters.UseByAtomBetter
        iex> Process.put(:required_key, 3)
        iex> UseByAtomBetter.required_key
        3
    """
    getter :required_key

    @doc ~S"""
        iex> alias MacroExamples.Getters.UseByAtomBetter
        iex> UseByAtomBetter.optional_key
        []
        iex> Process.put(:optional_key, 3)
        iex> UseByAtomBetter.optional_key
        3
        
    """
    getter optional_key: []
  end
end  
