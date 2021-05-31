defmodule DocTest do 
  use ExUnit.Case
  
  import MacroExamples.ModuleStructure.{Works,Use}
  doctest MacroExamples.ModuleStructure.Works
  doctest MacroExamples.ModuleStructure.Use

  import MacroExamples.Defchain.Use
  doctest MacroExamples.Defchain.Use


  doctest MacroExamples.Getters.Manual
  doctest MacroExamples.Getters.UseByName
  doctest MacroExamples.Getters.UseByAtom
  doctest MacroExamples.Getters.UseByAtomBetter

  doctest MacroExamples.HelperFunctions.BasicIdea
  doctest MacroExamples.HelperFunctions.BrokenUse
  doctest MacroExamples.HelperFunctions.WorkingUse
end
