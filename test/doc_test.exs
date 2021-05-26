defmodule DocTest do 
  use ExUnit.Case
  
  import MacroExamples.ModuleStructure.{Works,Use}
  doctest MacroExamples.ModuleStructure.Works
  doctest MacroExamples.ModuleStructure.Use

  import MacroExamples.Defchain.Use
  doctest MacroExamples.Defchain.Use
end
