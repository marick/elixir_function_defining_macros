defmodule MacroExamples.Inspect do

  @doc """
  `pe` expands quoted code (a syntax tree) and prints the
  resulting syntax tree in human-readable form. See the rest 
  of this file for an example of use.
  """
  def pe(env, quoted) do
    Macro.expand_once(quoted, env) |> Macro.to_string |> IO.puts
  end
end


defmodule MacroExamples.ExpansionViewer do 
  import MacroExamples.Inspect
  import MacroExamples.Defchain

  IO.puts "\n=== Below find an example of a macro expansion."
  IO.puts "=== It comes from `lib/inspect.ex`.\n"
  pe(__ENV__, quote do
      defchain assert_fields(map, pairs) when is_list(pairs) do
        for {key, expected} <- pairs do 
          assert Map.get(map, key) == expected
        end
      end
  end)
end

