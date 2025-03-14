defmodule Tiphx.Notebook do
  alias Tiphx.Notebook.Note

  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end
end
