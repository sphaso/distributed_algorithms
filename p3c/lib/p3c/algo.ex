defmodule P3C.Algo do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, {self, []}, name: :algo)
  end

  def init(state) do
    {:ok, state}
  end

  def run do
    ask_colors

    active?
    |> pick_color
    |> loop
  end

  def ask_colors do
    other_colors = Node.list
    |> Enum.map(fn node -> GenServer.call({:algo, node}, :answer) end)

    GenServer.call({:algo, Node.self}, {:update, other_colors})
  end

  def active? do
    GenServer.call({:algo, Node.self}, :activate)
  end

  def pick_color(true) do
    {_own, others} = local_state

    new_color = (0..(Node.list |> length))
    |> Enum.filter(fn n -> !(n in others) end)
    |> hd

    GenServer.call({:algo, Node.self}, {:update_own, new_color})

    nil
  end
  def pick_color(false) do
    possibilities = 0..(Node.list |> length)
    color = local_state |> elem(0)

    case color in possibilities do
      true -> color
      false -> nil
    end
  end

  def loop(nil), do: run
  def loop(color), do: IO.puts color

  def local_state do
    GenServer.call({:algo, Node.self}, :localstate)
  end

  def handle_call({:update, new_state}, _, {own, _}) do
    {:reply, :ok, {own, new_state}}
  end

  def handle_call({:update_own, color}, _, {_, others}) do
    {:reply, :ok, {color, others}}
  end

  def handle_call(:answer, _, state = {color, _}) do
    {:reply, color, state}
  end

  def handle_call(:activate, _, state = {own, others}) do
    possibilities = 0..(Node.list |> length)

    is_active = others
    |> Enum.all?(fn color -> !(own in possibilities) && own > color end)

    {:reply, is_active, state}
  end

  def handle_call(:localstate, _, state) do
    {:reply, state, state}
  end
end
