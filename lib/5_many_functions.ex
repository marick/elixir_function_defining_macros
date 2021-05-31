defmodule MacroExamples.ManyFunctions do
  
  # Support code for a series of articles on writing macros that expand into
  # definitions of named functions.
  #
  # This one is for https://www.crustofcode.com/def-macro-defdefdef.

  # ---------------------------------------------------------------------
  
  defmodule Definition do
    @unexpected_value "GUID"

    def checking_get(key, default) do
      result = Process.get(key, default)
      if result == @unexpected_value,
        do: raise "`#{key}` is not in the process dictionary"
      result
    end

    defp make_def(name_atom, default_ast) do
      quote do
        def unquote(name_atom)() do
          unquote(__MODULE__).checking_get(unquote(name_atom), unquote(default_ast))
        end
      end
    end

    defmacro getters(descriptions) when is_list(descriptions) do
      for one_description <- descriptions do
        case one_description do
          {name_atom, default_ast} ->
            make_def(name_atom, default_ast) 
          name_atom when is_atom(name_atom) ->
            make_def(name_atom, @unexpected_value)
        end
      end
    end

    # Why are the quotes necessary? Because `[name_atom]` expands into
    # [{:name_atom, [line: 43], nil}].
    defmacro getter(name_atom) when is_atom(name_atom) do
      quote do: getters([unquote(name_atom)])
    end

    defmacro getter(descriptions) do
      quote do: getters(unquote(descriptions))
    end

    #####

    def make_defs(descriptions) when is_list(descriptions) do
      for one_description <- descriptions do
        case one_description do
          {name_atom, default_ast} ->
            make_def(name_atom, default_ast) 
          name_atom when is_atom(name_atom) ->
            make_def(name_atom, @unexpected_value)
        end
      end
    end

    defmacro getter2(name_atom) when is_atom(name_atom) do
      make_defs([name_atom])
    end    
    
    defmacro getter2(descriptions) do
      make_defs(descriptions)
    end

  end

  defmodule Use do
    import Definition, only: [getters: 1, getter: 1, getter2: 1]

    getters(optional1: [], optional2: %{a: 1})
    getters [:list1, list2: Map.merge(%{b: 2}, optional2())]
    getter :getter_required
    getter getter_optional: 6


    getter2 :getter2_required
    getter2 getter2_optional: 6

  end
end
