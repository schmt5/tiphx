defmodule TiphxWeb.Ui.RichTextEditor do
  use Phoenix.Component

  import TiphxWeb.CoreComponents

  attr :id, :string, required: true
  attr :field, Phoenix.HTML.FormField, required: true

  attr :rest, :global

  def rich_text_editor(assigns) do
    ~H"""
    <div class="rich-text-editor">
      <div class="toolbar">
        <button data-tiptap-command="bold">
          <.icon name="hero-bold" class="h-5 w-5" /> <span class="sr-only">Bold</span>
        </button>

        <button data-tiptap-command="italic">
          <.icon name="hero-italic" class="h-5 w-5" /> <span class="sr-only">Italic</span>
        </button>

        <button data-tiptap-command="underline">
          <.icon name="hero-underline" class="h-5 w-5" /> <span class="sr-only">Underline</span>
        </button>

        <div class="separator" />

        <button data-tiptap-command="heading1">
          <.icon name="hero-h1" class="h-5 w-5" /> <span class="sr-only">Heading 1</span>
        </button>

        <button data-tiptap-command="heading2">
          <.icon name="hero-h2" class="h-5 w-5" /> <span class="sr-only">Heading 2</span>
        </button>

        <div class="separator" />

        <button data-tiptap-command="bulletList">
          <.icon name="hero-list-bullet" class="h-5 w-5" /> <span class="sr-only">Bullet List</span>
        </button>
        <button data-tiptap-command="orderedList">
          <.icon name="hero-numbered-list" class="h-5 w-5" />
          <span class="sr-only">Ordered List</span>
        </button>
      </div>
      <div id={@id} phx-hook="TiptapHook" />

      <.input type="text" {@rest} field={@field} phx-debounce="blur" />
    </div>
    """
  end
end
