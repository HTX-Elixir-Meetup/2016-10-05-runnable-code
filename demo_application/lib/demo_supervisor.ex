defmodule DemoApplication.DemoSupervisor do
  alias DemoApplication.DemoModule
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: :demo_supervisor)
  end


  def init(_) do
  children = [
    worker(DemoModule, [])
  ]

  supervise(children, strategy: :one_for_one)
  end 
  

end