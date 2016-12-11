defmodule P2C.Algo do
  use GenServer

  @colors [1, 2]

  def start_link do
    GenServer.start_link(__MODULE__, {Node.self, []}, name: :algo)
  end

  def init(state) do
    {:ok, state}
  end

  def run do
    pass_ed_info
    |> do_run
  end

  def do_run(:ok), do: run
  def do_run(:stop) do
    activate?
  end

  def pass_ed_info do
    {_, endpoints} = local_state

    case endpoints |> length do
      2 -> :stop
      _ -> case Node.list |> length do
            1 -> GenServer.call({:algo, Node.self}, :pass_ed_info)
            _ -> :ok
           end
    end
  end

  def activate? do
    {own, endpoints} = local_state

    is_endpoint = Node.list |> length |> Kernel.==(1)
    is_min = Enum.min(endpoints) == Node.self

    case own in @colors do
      true -> IO.puts own
      _ -> case is_endpoint && is_min do
              true -> GenServer.cast({:algo, Node.self}, {:pick_color, {Node.self, 1}})
                      activate?
              _ -> activate?
           end
    end
  end

  def local_state do
    GenServer.call({:algo, Node.self}, :localstate)
  end

  def next_node(receiver) do
    Node.list
    |> Enum.filter(fn x -> x != receiver end)
  end

  def handle_call(:pass_ed_info, _, {_, endpoints}) do
    GenServer.cast({:algo, Node.list |> hd}, {:receive_info, {Node.self, [Node.self]}})

    {:reply, :ok, {Node.self, [Node.self]}}
  end

  def handle_cast({:receive_info, {receiver, points}}, {own, endpoints}) do
    updated = points
    |> Enum.filter(fn x -> !(x in endpoints) end)
    |> Kernel.++(endpoints)

    next = next_node(receiver)

    case next do
      [] -> {:noreply, {own, updated}}
      ns -> GenServer.cast({:algo, ns |> hd}, {:receive_info, {Node.self, updated}})
    end

    {:noreply, {own, updated}}
  end

  def handle_cast({:pick_color, {receiver, color}}, {_, endpoints}) do
    new_color = @colors
    |> Enum.find(fn c -> c != color end)

    next = next_node(receiver)

    case next do
      [] -> {:noreply, {new_color, endpoints}}
      ns -> GenServer.cast({:algo, ns |> hd}, {:pick_color, {Node.self, new_color}})
    end

    {:noreply, {new_color, endpoints}}
  end

  def handle_call(:localstate, _, state) do
    {:reply, state, state}
  end
end
