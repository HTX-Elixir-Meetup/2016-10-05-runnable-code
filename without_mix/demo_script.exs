defmodule DemoModule do
  def say_it() do
    IO.puts "Hello from #{__MODULE__}"
  end
end

DemoModule.say_it