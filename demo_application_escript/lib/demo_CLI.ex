defmodule DemoApplication.CLI do
  alias DemoApplication.DemoModule

  def main(args) do
    args |> parse_args() |> do_process()
  end

  def parse_args(args) do
    options = OptionParser.parse(args, aliases: [h: :help])

    case options do
      {[help: true], _, _} -> :help
      _ -> :run
    end
  end

  def do_process(:run) do
    DemoModule.say_it(:demo_module)
  end

  def do_process(:help) do
    IO.puts """
    Welcome to Demo App.

    """
  end
end
