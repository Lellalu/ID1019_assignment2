defmodule EnvList do

  def new() do [] end

  def add(map, key, value) do
    add(map, key, value, [])
  end
  def add([], key, value, acc) do
    [{key, value} | acc]
  end
  def add([{k, _} | rest], key, value, acc) when k === key do
    acc ++ [{key, value} | rest]
  end
  def add([pair | rest], key, value, acc) do
    add(rest, key, value, acc ++ [pair])
  end

  def remove(key, map) do
    remove(key, map, [])
  end
  def remove(_, [], acc) do
    acc
  end
  def remove(key, [{k, _} | rest], acc) when k === key do
    acc ++ rest
  end
  def remove(key, [pair | rest], acc) do
    remove(key, rest, acc ++ [pair])
  end

  def lookup(_, []) do
    nil
  end
  def lookup(key, [{k, v} | _]) when k===key do
    {k, v}
  end
  def lookup(key, [_ | rest]) do
    lookup(key, rest)
  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq, EnvList.new(),fn(e,list)-> EnvList.add(list,e,:foo) end)
    seq = Enum.map(1..n,fn(_) -> :rand.uniform(i) end)
    {add,_} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvList.add(list, e, :foo)
    end) end)

    {lookup,_} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvList.lookup(list,e)
    end) end)

    {remove,_} = :timer.tc(fn()-> Enum.each(seq,fn(e)-> EnvList.remove(list,e)
    end) end)

    {i,add,lookup,remove}

  end
end
