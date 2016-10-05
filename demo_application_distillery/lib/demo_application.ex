defmodule DemoApplication do
  alias DemoApplication.{DemoSupervisor, DemoModule}
  use Application 

  def start(_type, _args) do
    DemoSupervisor.start_link()
  end

  def use_module() do
    DemoModule.say_it(:demo_module)
  end
end
