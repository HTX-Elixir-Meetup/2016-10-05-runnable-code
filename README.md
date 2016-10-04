# 2016-10-05-runnable-code

## Flavors:

* Compile from command line / REPL
* Running Elixir Script (`.exs`)
* Compile from Mix
* Application behaviour
* Escript
* Releases & Distillery



## Compile From Command Line/REPL
The REPL / iex is a great place to test out expressions and general functionality of a module in real time. If you have a file in Elixir that you want to compile and load into the REPL, use the `c/1` command. 

```
$ iex
Erlang/OTP 19 [erts-8.1] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.3.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> c "demo_module.ex"
[DemoModule]
iex(2)> DemoModule.say_it
Hello from Elixir.DemoModule
:ok
iex(3)>
```

Additionally, the user can keep the same iex session after making changes to code. Use command `recompile/0` from iex.



## Running Elixir Script (.exs)
Elixir can run in an interpreted, scripted form. These files have the extension `.exs` to differentiate from compilable Elixir code. `.exs` files are typically used for configuration. These files can be exectured directly from the command line by calling on Elixir to run, or by loading it into iex. Note that loading the script into iex will execute the script eagerly.

```
$ elixir demo_script.exs
Hello from an Elixir script!
```

or

```
iex(1)> c "demo_script.exs"
Hello from an Elixir script!
[]
iex(2)>
```


## Using Mix
Once your codebase expands beyond a few modules, or you start to include dependencies, you will want to start using a tool to manage the code. Mix ships with Elixir, and functions as a test runner, dependency manager, and a build tool. 

You can even start iex sessions and let mix compile and load in your modules and listed dependencies:

```
$ iex -S mix
Erlang/OTP 19 [erts-8.1] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Compiling 1 file (.ex)
Generated with_mix app
Interactive Elixir (1.3.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> WithMix.say_it
Hello from Elixir.WithMix
:ok
```

## Detour: Using the Application Behaviour
The `Application` behaviour is used typically in a module that exposes a public-facing API. `Application` is responsible for starting your supervision trees, and calling any cleanup code when your application exits. 


The new application module looks like this (`demo_application.ex`):

```
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
```



You would also specify this module in the `application/0` function in your `mix.exs` file:

```
  def application do
    [
      applications: [:logger],
      mod: {DemoApplication, []}
    ]
  end
```

Mix will use the `start/2` callback in the module you specify, along with any arguments specified in the second element of the tuple. 

## Escripts
Generates an executable from BEAM files. Requires the user already have the VM installed. Good practice to have a separate module for running the code. 

To use an Escript, you will need a separate module to run the code from the script. We'll create a module called `demo_CLI.ex` in our lib directory. It requires a function called `main` that accepts arguments from the command line. The module looks like this:

```
defmodule DemoApplication.CLI do
  alias DemoApplication.DemoModule

  def main(args) do
    args |> parse_args |> do_process
  end

  def parse_args(args) do
    options = OptionParser.parse(args)

    case options do
      {[help: true], _, _} -> :help
      {[h: true], _, _}   -> :help
      _ -> :run
    end
  end

  def do_process(:run) do
    DemoModule.say_it(:demo_module)
  end

  def do_process(:help) do
    IO.puts("Welcome to Demo App.")
  end
end
```


In `mix.exs`, include the following within the `project/0` function: `escript: escript` and create a new `escript/0` function: 

```
def escript, do: [main_module: HouTax.CLI]
```


Then compile the script:
```
$ mix escript.build
Compiling 4 files (.ex)
Generated demo_application app
Generated escript demo_application with MIX_ENV=dev
```

This creates an executable called `demo_application`. You can run it immediately with `./demo_application`.



## Releases with Distillery
Generates an executable from BEAM files and includes the VM. Should be compiled on the target OS.