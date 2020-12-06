defmodule PhoenixBaseWeb.Helpers.PresenceHelper do
  alias PhoenixBaseWeb.Presence

  def getFreeAgentIDs(socket) do
    uid = socket.assigns.user_id

    Presence.list(socket)
    |> Enum.filter(fn {k, %{metas: metas}} ->
      curMeta = getCurrentMeta(metas)
      uid !== k && Map.get(curMeta, "status") === "searching"
    end)
    |> Enum.map(fn {k, %{metas: _metas}} -> k end)
  end

  def getMyCurrentMeta(socket) do
    %{metas: curMetas} = Presence.get_by_key(socket, socket.assigns.user_id)
    getCurrentMeta(curMetas)
  end

  def getCurrentMeta(metas) do
    Enum.reduce(metas, nil, fn new, acc ->
      if acc === nil do
        new
      else
        if new.online_at > acc.online_at, do: new, else: acc
      end
    end)
  end

  def update(socket, newMap) do
    now = inspect(System.system_time(:second))

    {:ok, _} =
      Presence.update(
        socket,
        socket.assigns.user_id,
        &(Map.merge(&1, newMap) |> Map.put(:online_at, now))
      )
  end
end
