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
    changeset = Notebook.change_note(%Note{}, note)
    {:noreply, socket |> assign(:form, to_form(changeset))}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="text-4xl">Rich Text Editor with Form</h1>
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

      <h2 class="text-2xl mt-24 mb-8">Get Started</h2>
      <p class="text-lg">
        This example demonstrates how to use the Tiptap editor with a Phoenix form. The editor is a Phoenix.Component that uses the Tiptap editor via a hook. The editor works with Ecto changesets like any other form input.
      </p>
      <p class="text-lg mt-4">
        Check out the gists below or the
        <a
          href="https://github.com/schmt5/tiphx"
          alt="Source Code on GitHub"
          class="text-blue-600 underline"
        >
          Source Code on GitHub
        </a>
      </p>

      <div id="notebook-gist" phx-update="ignore" class="my-12">
        <p class="p-4 my-4 bg-sky-50 rounded-lg border border-sky-600 text-lg">
          Rich text editor component works like standard form inputs.
          Include it within a form and bind to a form field.
        </p>
        <script src="https://gist.github.com/schmt5/59ff6125cabc88399e551f3851790288.js">
        </script>
      </div>

      <div id="rich-text-editor-gist" phx-update="ignore" class="my-12">
        <p class="p-4 my-4 bg-sky-50 rounded-lg border border-sky-600 text-lg">
          The .rich_text_editor component is a Phoenix.Component that uses the Tiptap editor via a hook. Look at the phx-debounce="blur" attribute on the .input element. This will trigger the validate event when the rich text editor loses focus.
        </p>
        <script src="https://gist.github.com/schmt5/b27c5939f17641e87ed89e47bea32a3a.js">
        </script>
      </div>

      <div id="tiptap-hook-gist" phx-update="ignore" class="my-12">
        <p class="p-4 my-4 bg-sky-50 rounded-lg border border-sky-600 text-lg">
          Here you can see the tiptap hook.
        </p>
        <script src="https://gist.github.com/schmt5/4a4a9214240836cd1722959b61b3b0b3.js">
        </script>
      </div>

      <div id="note-gist" phx-update="ignore" class="my-12">
        <p class="p-4 my-4 bg-sky-50 rounded-lg border border-sky-600 text-lg">
          The editor works with Ecto changesets like any other form input.
        </p>
        <script src="https://gist.github.com/schmt5/9d579c0e450eaad0a234350d9c8d45d6.js">
        </script>
      </div>
    </div>
    """
  end
end
