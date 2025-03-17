defmodule TiphxWeb.NotebookLive do
  use TiphxWeb, :live_view
  alias Tiphx.Notebook
  alias Tiphx.Notebook.Note

  def mount(_params, _session, socket) do
    changeset = Notebook.change_note(%Note{})

    {:ok,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:subject_to_display, "")
     |> assign(:content_to_display, "")}
  end

  def handle_event("save", %{"note" => note}, socket) do
    changeset = Notebook.change_note(%Note{}, note)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:subject_to_display, changeset.params["subject"])
     |> assign(:content_to_display, changeset.params["content"])}
  end

  def handle_event("validate", %{"note" => note}, socket) do
    IO.inspect(note)
    changeset = Notebook.change_note(%Note{}, note)
    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <.simple_form for={@form} id="notebook-form" phx-change="validate" phx-submit="save">
        <.input label="Subject" field={@form[:subject]} phx-debounce="500" />
        <.rich_text_editor id="my-editor" field={@form[:content]} />

        <:actions>
          <.button type="submit">Submit Form</.button>
        </:actions>
      </.simple_form>

      <div :if={@subject_to_display != ""} class="mt-4">
        <p class="font-bold">Subject</p>
        <p>{@subject_to_display}</p>
      </div>

      <div :if={@content_to_display != ""} class="mt-4">
        <p class="font-bold">Content</p>
        <p>{@content_to_display}</p>
      </div>
    </div>
    """
  end
end
