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

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:subject_to_display, changeset.params["subject"])
     |> assign(:content_to_display, changeset.params["content"])}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <h1 class="font-semibold text-6xl">Phoenix <span class="gradient-text">TipTap</span> Editor</h1>
      <.simple_form for={@form} id="notebook-form" phx-change="validate" phx-submit="save">
        <.input label="Subject" field={@form[:subject]} phx-debounce="500" />
        <.rich_text_editor id="my-editor" field={@form[:content]} />

        <:actions>
          <.button type="submit">Submit Form</.button>
        </:actions>
      </.simple_form>

      <div class="my-4 bg-gray-50 border border-gray-300 p-4 rounded-lg h-64 overflow-auto">
        <p>> {@subject_to_display}</p>
        <p>> {@content_to_display}</p>
      </div>
      <h2 class="text-4xl mt-24 mb-8">Get Started</h2>
      <p class="text-lg">
        This example demonstrates how to use the Tiptap editor with a Phoenix form. The editor is a Phoenix.Component that uses the Tiptap editor via a hook. The editor works with phoenix FormData (to_form) and ecto changeset like any other form input.
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

      <div id="note-gist" phx-update="ignore" class="mb-20 mt-24">
        <h3 class="text-3xl">Core</h3>
        <p class="italic text-lg mb-4">lib/tiphx/notebook/note.ex</p>
        <p class="text-lg">
          We start by creating our schema. In the core we can model changes with ecto changesets. Ecto changesets are policies for how changing data.
        </p>
        <p class="text-lg mt-2">
          Data can be persist in a database or we can use embedded schemas.
        </p>
        <div class="-mx-20 my-8 h-80 overflow-auto">
          <script src="https://gist.github.com/schmt5/9161a66d8663a9f4f4024f792822e00a.js">
          </script>
        </div>
      </div>

      <div id="notebook-gist" phx-update="ignore" class="mb-20">
        <h3 class="text-3xl">Context</h3>
        <p class="italic text-lg mb-4">lib/tiphx/notebook.ex</p>
        <p class="text-lg">
          The context is the boundary layer between our predictable core and live_view
        </p>
        <div class="-mx-20 my-8 overflow-auto">
          <script src="https://gist.github.com/schmt5/4335c4205204ff5a897d80c5e814331b.js">
          </script>
        </div>
      </div>

      <div id="liveview-gist" phx-update="ignore" class="mb-20">
        <h3 class="text-3xl">Liveview</h3>
        <p class="italic text-lg mb-4">lib/tiphx_web/live/notebook.ex</p>
        <p class="text-lg">
          In our LiveView, we assign our form using <code>to_form()</code>
          and handle both validate and save events.  The .rich_text_editor component works like the standard .input using form field.
        </p>
        <p class="text-lg mt-2">
          Check out the "👈" for the most interesting parts
        </p>
        <div class="-mx-20 my-8 h-80 overflow-auto">
          <script src="https://gist.github.com/schmt5/6f1395e5b28d79c778a45eeadb44da4f.js">
          </script>
        </div>
      </div>

      <div id="rich-text-editor-gist" phx-update="ignore" class="mb-20">
        <h3 class="text-3xl">Rich Text Editor Component</h3>
        <p class="italic text-lg mb-4">lib/tiphx_web/components/ui/rich_text_editor.ex</p>
        <p class="text-lg">
          The .rich_text_editor component is a Phoenix.Component that uses the Tiptap editor via a hook. Look at the phx-debounce="blur" attribute on the .input element.
          This will trigger the validate event when the rich text editor loses focus.
        </p>
        <p class="text-lg mt-2">
          Check out the "👈" for the most interesting parts
        </p>
        <div class="-mx-20 my-8 h-96 overflow-auto">
          <script src="https://gist.github.com/schmt5/115ffc3541f0d44870ebd294e96b13e6.js">
          </script>
        </div>
      </div>

      <div id="tiptap-hook-gist" phx-update="ignore" class="mb-20">
        <h3 class="text-3xl">TipTap Hook</h3>
        <p class="italic text-lg mb-4">assets/js/hooks/tiptap_hook.js</p>
        <p class="text-lg">
          TipTap hook is a custom phoenix hook that initializes the TipTap editor.
        </p>
        <p class="text-lg mt-2">
          The html content is set to the input field when the editor is updated.
          When the editor looses focus, an input event is bubbling up which triggers the validate event of the form.
        </p>
        <p class="text-lg mt-2">
          Check out the "👈" for the most interesting parts
        </p>
        <div class="-mx-20 my-8 h-96 overflow-auto">
          <script src="https://gist.github.com/schmt5/11db1b7c06a24bb63bfd9a716e7bb251.js">
          </script>
        </div>
      </div>
    </div>
    """
  end
end
