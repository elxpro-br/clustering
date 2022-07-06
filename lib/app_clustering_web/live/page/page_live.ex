defmodule AppClusteringWeb.PageLive do
  use AppClusteringWeb, :live_view
  alias Phoenix.PubSub
  @pubsub AppClustering.PubSub
  @topic "inc"

  def mount(_, _, socket) do
    if connected?(socket), do: PubSub.subscribe(@pubsub, @topic)
    {:ok, assign(socket, count: 0)}
  end

  def handle_event("inc", _, socket) do
    PubSub.broadcast(@pubsub, @topic, :inc)
    {:noreply, socket}
  end

  def handle_info(:inc, socket) do
    {:noreply, update(socket, :count, &(&1 + 1))}
  end
end
