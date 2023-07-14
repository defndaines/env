# Elixir

These are shortcuts, commands, and notes about using Elixir.

## Debugging from Command Line

Prefix with `MIX_DEBUG=1`

## Recompile Code without Restart

```elixir
recompile()
```

## `.iex.exs`

Remember that anything in `.iex.exs` of project root will get loaded when
starting IEx, so useful for test data and the like.

## Logical Cores

Automatic parallelism, such as with `Task.async*`, defaults to the number of
logical cores. See the value with
```elixir
System.schedulers_online()
```
or
```elixir
:erlang.system_info(:logical_processors_available)
```

## Get the Last Result

Pass an argument to get specific line number. Defaults to `-1`, last line.
```elixir
v()
```

## See Entire Result

IEx by default shortens long results. To get around it,
```elixir
fun() |> IO.inspect(limit: :infinity)
```

## Abort Syntax Error

If you have some bad syntax in IEx, like a dangling parenthesis or quote, this
will dump the statement.
```elixir
#iex:break
```

## Miscellaneous References

https://paraxial.io/blog/throttle-requests
  - https://github.com/michalmuskala/plug_attack

## Quick Timing Check

To quickly get a sense of how long something is taking, wrap it in
`:timer.tc/1`. It returns result in μs (microseconds)

```elixir
{time, result} = :timer.tc(fn ->
  # code to test here
end)

IO.inspect(time, label: :microseconds)
result
```

## Truncate

Dangerous to use, even for testing.
```elixir
Ecto.Repo.query("TRUNCATE #{Module.Name.__schema__(:source)}", [])
```

## Docs

To output the formatted docs.
```elixir
h Your.Module.Name
```

To see the exported functions of a module.
```elixir
exports Your.Module
```
