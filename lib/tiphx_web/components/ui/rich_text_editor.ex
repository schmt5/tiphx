defmodule TiphxWeb.Ui.RichTextEditor do
  use Phoenix.Component

  import TiphxWeb.CoreComponents

  attr :id, :string
  attr :value, :string
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
      </div>
       <div id={@id} phx-hook="TiptapHook" data-content={@value} />
      <input type="hidden" name="content" value={@value} />
    </div>
    """
  end
end
