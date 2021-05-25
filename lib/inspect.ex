defmodule MacroExamples.Inspect do


  def pe(env, quoted) do
    Macro.expand_once(quoted, env) |> Macro.to_string |> IO.puts
  end
end

