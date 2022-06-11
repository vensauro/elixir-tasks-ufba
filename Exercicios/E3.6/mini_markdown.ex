# mini_markdown.ex
defmodule MiniMarkdown do
  def to_html(text) do
    text
    |> p
    |> bold
    |> italics
  end

  def bold(text), do: Regex.replace(~r/\*\*(.*)\*\*/, text, "<strong>\\1</strong>")
  def italics(text), do: Regex.replace(~r/\*(.*)\*/, text, "<em>\\1</em>")

  def p(text) do
    Regex.replace(~r/(\r\n|\r|\n|^)+([^\r\n]+)((\r\n|\r|\n)+$)?/, text, "<p>\\1</p>")
  end
end
