# guessing_game
defmodule GuessingGame do
  @moduledoc """
    Provides a game, that the user think in a number between 0 and 10k,
    and the program will try to guess that number
  """

  def guess() do
    IO.puts("Pense em um número de 0 até 10000")
    # how can i add random number to enhance the algorithm?
    rand_n = 0..10000 |> Enum.random()

    case IO.gets("É o número #{rand_n}? ") |> String.trim() do
      "maior" ->
        guess(rand_n, 10000)

      "menor" ->
        guess(0, rand_n)

      "sim" ->
        "De primeira, sou bom de mais!!!"

      _ ->
        IO.puts("Não entendi, pensarei em outro número")
        guess(0, 10000)
    end
  end

  def guess(a, b) when a == b, do: "O número que você pensou é #{a}"

  def guess(a, b) when a > b, do: guess(b, a)

  def guess(low, high) do
    IO.gets("Você pensou no número #{mid(low, high)}?\n")
    |> String.trim()
    |> compute_answer(low, high)
  end

  defp mid(low, high) do
    div(low + high, 2)
  end

  defp compute_answer("maior", low, high) do
    resposta = mid(low, high)
    menor = min(high, resposta + 1)
    guess(menor, high)
  end

  defp compute_answer("menor", low, high) do
    resposta = mid(low, high)
    maior = max(low, resposta - 1)
    guess(low, maior)
  end

  defp compute_answer("sim", _, _) do
    "Sabia que era esse número, sou um gênio!"
  end

  defp compute_answer(_, low, high) do
    IO.puts(~s{Digite "maior", "menor" or "sim"})
    guess(low, high)
  end
end

GuessingGame.guess() |> IO.puts()
