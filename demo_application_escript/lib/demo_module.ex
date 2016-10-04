defmodule DemoApplication.DemoModule do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: :demo_module)
  end

  def init(_) do
    {:ok, nil}
  end

  def say_it(pid) do
    GenServer.call(pid, {:say_it})
  end

  def handle_call({:say_it}, _from, _arg) do
    IO.puts "Hello from #{__MODULE__}!"
    {:reply, :ok, :nil}
  end

  def handle_info(_, state), do: {:noreply, state}

end