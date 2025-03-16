defmodule TiphxWeb.NotebookLive do
  use TiphxWeb, :live_view
  alias Tiphx.Notebook
  alias Tiphx.Notebook.Note

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:content_to_display, "") |> assign_form()}
  end

  def handle_event("save", %{"note" => note}, socket) do
    changeset = Notebook.change_note(%Note{}, note)
    {:noreply, socket |> assign(:content_to_display, changeset.params["content"])}
  end

  defp assign_form(socket) do
    changeset = Notebook.change_note(%Note{})
    socket |> assign(:form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <.simple_form for={@form} id="notebook-form" phx-submit="save">
        <.rich_text_editor id="my-editor" field={@form[:content]} />

        <:actions>
          <.button type="submit">Submit Form</.button>
        </:actions>
      </.simple_form>

      <div :if={@content_to_display != ""} class="mt-4">
        <h2 class="text-xl">Content</h2>
        <p>{@content_to_display}</p>
      </div>
    </div>
    """
  end
end
