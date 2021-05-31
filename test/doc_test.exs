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


  test "many functions doesn't have doc strings" do
    import MacroExamples.ManyFunctions.Use

    assert optional1() == []
    assert optional2() == %{a: 1}

    assert_raise(RuntimeError, "`list1` is not in the process dictionary", fn ->
      list1()
    end)
    assert list2() == %{a: 1, b: 2}


    assert_raise(RuntimeError, "`getter_required` is not in the process dictionary", fn ->
      getter_required()
    end)


    assert getter_optional() == 6

    
    assert_raise(RuntimeError, "`getter2_required` is not in the process dictionary", fn ->
      getter2_required()
    end)


    assert getter2_optional() == 6
  end
end
