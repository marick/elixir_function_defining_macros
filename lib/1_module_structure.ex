defmodule MacroExamples.ModuleStructure do

  # Support code for a series of articles on writing macros that expand into
  # definitions of named functions.
  #
  # This one is for https://www.crustofcode.com/def-macro-defmacrop/

  # ---------------------------------------------------------------------

  # An ordinary macro can be used within the module that defines i.
  defmodule Works do

    defmacrop plus(a, b) do
      quote do
        unquote(a) + unquote(b)
      end
    end

    @doc ~S"""
        iex> plus_client()
        3
    """
    def plus_client do
      plus(1, 2)
    end
  end

  # ---------------------------------------------------------------------

  # If you uncomment the code, you'll see that the use of `defadder` doesn't
  # "see" its definition.
  defmodule NotForFunctions do 
    # defmacrop defadder(addend) do
    #   quote do
    #     def adder(n), do: n + unquote(addend)
    #   end
    # end
    
    # defadder 4
  end

  # That's not a property of macros but rather of compiling top-level forms.
  defmodule TopLevel do
    # def add1(n), do: n+1
    # IO.inspect add1(1)
  end
  
  # ---------------------------------------------------------------------

  # So you must separate the definition of a macro from its uses.
  defmodule Definition do
    defmacro defadder(addend) do
      quote do
        def adder(n), do: n + unquote(addend)
      end
    end
  end

  defmodule Use do
    import Definition

    @doc ~S"""
        iex> adder(3)
        7
    """
    defadder 4
  end
end
