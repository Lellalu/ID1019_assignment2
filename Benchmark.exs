defmodule Benchmark do
  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    #IO.inspect(seq)
    list = Enum.reduce(seq, EnvList.new(),fn(e,list)-> EnvList.add(list,e,:foo) end)
    #IO.inspect(list)
    seq = Enum.map(1..n,fn(_) -> :rand.uniform(i) end)
    #IO.inspect(seq)
    {add,_} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvList.add(list, e, :foo)
    end) end)

    {lookup,_} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvList.lookup(e,list)
    end) end)

    {remove,_} = :timer.tc(fn()-> Enum.each(seq,fn(e)-> EnvList.remove(e,list)
    end) end)

    {i,add,lookup,remove}
  end

  def bench2(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    #IO.inspect(seq)
    tree = Enum.reduce(seq, EnvTree.new(),fn(e,tree)-> EnvTree.add(tree,e,:foo) end)
    #IO.inspect(tree)
    seq = Enum.map(1..n,fn(_) -> :rand.uniform(i) end)
    #IO.inspect(seq)
    {add,_} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvTree.add(tree, e, :foo)
    end) end)

    {lookup,_} = :timer.tc(fn() -> Enum.each(seq, fn(e) -> EnvTree.lookup(tree, e)
    end) end)

    {remove,_} = :timer.tc(fn()-> Enum.each(seq,fn(e)-> EnvTree.remove(tree, e)
    end) end)

    {i,add,lookup,remove}
  end

  def benchList(n) do
    ls=[16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("#benchmark with ~w operations,time per operation in us\n",[n])
    :io.format("~6.s~12.s~12.s~12.s\n",["n","add","lookup","remove"])
    Enum.each(ls,fn(i)-> {i, tla, tll, tlr} = bench(i, n)
    :io.format("~6.w~12.2f~12.2f~12.2f\n",[i, tla/n, tll/n, tlr/n]) end)
  end

  def benchTree(n) do
    ls=[16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("#benchmark with ~w operations,time per operation in us\n",[n])
    :io.format("~6.s~12.s~12.s~12.s\n",["n","add","lookup","remove"])
    Enum.each(ls,fn(i)-> {i, tla, tll, tlr} = bench2(i, n)
    :io.format("~6.w~12.2f~12.2f~12.2f\n",[i, tla/n, tll/n, tlr/n]) end)
  end
end
