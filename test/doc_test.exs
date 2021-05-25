defmodule DocTest do 
  use ExUnit.Case
  import MacroExamples.Inspect
  
  import MacroExamples.Defmacrop.{Works,Use}
  doctest MacroExamples.Defmacrop.Works
  doctest MacroExamples.Defmacrop.Use


  import MacroExamples.Defchain
  import MacroExamples.Defchain.Use
  doctest MacroExamples.Defchain.Use


  test "scratch" do
    pe(__ENV__, quote do: assert_field(map, a: 3))
  end    
  
end
