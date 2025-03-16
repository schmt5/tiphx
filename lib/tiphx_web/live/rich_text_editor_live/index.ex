defmodule TiphxWeb.RichTextEditorLive.Index do
  use TiphxWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, content: "dasfd")}
  end

  def handle_event("update_content", %{"content" => content}, socket) do
    IO.inspect("update content")
    {:noreply, assign(socket, content: content)}
  end

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <div class="container">
      <form phx-change="update_content">
        <label for="my-editor" class="block">Content</label>
        <input id="my-editor" name="content" value={@content} />
      </form>

      <div class="mt-8">
        ppp
        <p>{@content}</p>
      </div>
    </div>
    """
  end
end
