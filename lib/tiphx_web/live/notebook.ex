defmodule TiphxWeb.NotebookLive do
  use TiphxWeb, :live_view
  alias Tiphx.Notebook
  alias Tiphx.Notebook.Note

  def mount(params, session, socket) do
    {:ok, socket |> assign(:content, "") |> assign_form()}
  end

  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset = Notebook.change_note(%Note{}, note_params) |> Map.put(:action, :validate)
    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", params, socket) do
    content = get_in(params, ["note", "content"])
    {:noreply, socket |> assign(:content, content)}
  end

  defp assign_form(socket) do
    changeset = Notebook.change_note(%Note{})
    socket |> assign(:form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <.simple_form for={@form} id="notebook-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:content]} type="textarea" label="Note" />
        <:actions>
          <.button type="submit">Save</.button>
        </:actions>
      </.simple_form>

      <div :if={@content != ""} class="mt-8">
        <p class="font-bold">Form</p>
        <p>{@content}</p>
      </div>
    </div>
    """
  end
end
