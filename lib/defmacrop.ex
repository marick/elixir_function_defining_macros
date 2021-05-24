defmodule MacroExamples.Defmacrop do
  
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


  defmodule NotForFunctions do 
    # defmacrop defadder(addend) do
    #   quote do
    #     def adder(n), do: n + unquote(addend)
    #   end
    # end
    
    # defadder 4
  end


  defmodule TopLevel do
    # def add1(n), do: n+1
    # IO.inspect add1(1)
  end
  

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
