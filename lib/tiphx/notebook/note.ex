defmodule Tiphx.Notebook.Note do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field :content, :string
  end

  def changeset(note, attrs) do
    attrs = sanitize_attrs(attrs)

    note
    |> cast(attrs, [:content])
  end

  defp sanitize_attrs(%{"content" => _content} = attrs) do
    Map.update!(attrs, "content", &HtmlSanitizeEx.basic_html/1)
  end

  defp sanitize_attrs(attrs), do: attrs
end
