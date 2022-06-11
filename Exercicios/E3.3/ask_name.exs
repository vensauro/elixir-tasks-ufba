ExUnit.start()

defmodule AskNameTest do
  use ExUnit.Case
  doctest AskName

  test "answer for ivens name" do
    assert AskName.answer("ivens") == "Hello ivens, how are you?"
  end

  test "wrong answer for renato name" do
    assert WC.start("../../aulas.md") == :ok
  end
end
