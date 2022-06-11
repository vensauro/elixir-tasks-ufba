ExUnit.start()

defmodule WCTest do
  use ExUnit.Case
  doctest WC

  test "run wc from aulas.md file" do
    assert WC.start("../../aulas.md") == "  9 15 170 ../../aulas.md"
  end

  test "run wc from aulas.md file and expect wrong result" do
    assert WC.start("../../aulas.md") == :ok
  end

  # test "wc throw error" do
  #   assert WC.start("aulas.md") == :ok
  # end
end
