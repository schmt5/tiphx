defmodule TiphxWeb.RichTextEditorLive.Index do
  use TiphxWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, content: "jkjk")}
  end

  def handle_event("set_content", params, socket) do
    {:noreply, assign(socket, content: "Hello, TipTap!")}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <.rich_text_editor id="my-editor" value={@content} />
      <div class="mt-8">
        <.button phx-click="set_content">Set TipTap content</.button>
        <p>{@content}</p>
      </div>
    </div>
    """
  end
end
