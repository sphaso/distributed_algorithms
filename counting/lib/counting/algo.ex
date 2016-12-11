defmodule Counting.Algo do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, 0, name: :algo)
  end

  def init(state) do
    {:ok, state}
  end

  def run do
    activate?
  end

  def activate? do
    case is_endpoint? do
        true -> GenServer.cast({:algo, Node.list |> hd}, {:count, {Node.self, 1}})
        _ -> activate?
    end
  end

  def local_state do
    GenServer.call({:algo, Node.self}, :localstate)
  end

  def is_endpoint? do
    Node.list |> length |> Kernel.==(1)
  end

  def next_node(receiver) do
    Node.list
    |> Enum.filter(fn x -> x != receiver end)
  end

  def spread_the_word([], number), do: number
  def spread_the_word(nodes, number) do
    nodes
    |> Enum.each(fn n -> GenServer.cast({:algo, n}, {:update, {Node.self, number}}) end)

    number
  end

  def handle_cast({:count, {receiver, delta}}, count) do
    number = count + delta + 1

    updated = case count > 0 || is_endpoint? do
                true -> Node.list
                        |> spread_the_word(number)
                        |> IO.puts

                        number
                _    -> GenServer.cast({:algo, next_node(receiver) |> hd}, {:count, {Node.self, delta + 1}})
                        delta + 1
              end

    {:noreply, updated}
  end

  def handle_cast({:update, {receiver, number}}, _) do
    receiver
    |> next_node
    |> spread_the_word(number)
    |> IO.puts

    {:noreply, number}
  end

  def handle_call(:localstate, _, state) do
    {:reply, state, state}
  end
end
