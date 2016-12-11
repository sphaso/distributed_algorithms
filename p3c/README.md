# P3C

Elixir implementation of the coloring algorithm in Chapter 1 of `Distributed Algorithms` by `Jukka Suomela`.        
Since in Elixir, by default, connected nodes form an equivalence relationship, the nodes are not in a path but rather in a Kn graph.     

## How to use

- Open as many shells as you fancy
- Go to the project's directory
- run on each shell: `iex --sname {DISTINCT_NAME} --cookie {SECRET} -S mix` where `{DISTINCT_NAME}` is a distinct string for each shell but `{SECRET}` is the same
- connect each iex shell with `Node.connect :{DISTINCT_NAME}@{HOST}`, the full name corresponds to the iex prompt      
- run on each iex shell `P3C.Algo.run`
- jump up and down if you see different numbers! (where `n < |nodes|`)

e.g.

`iex --sname foo --cookie secret -S mix`          
`iex --sname bar --cookie secret -S mix`       
`iex --sname star --cookie secret -S mix`       
`iex(foo@localhost)1> Node.connect :bar@localhost`        
`iex(foo@localhost)2> Node.connect :star@localhost`

All three shells are connected! (can you see why? :)         

`iex(foo@localhost)3> P3C.Algo.run`         
`iex(bar@localhost)1> P3C.Algo.run`         
`iex(star@localhost)1> P3C.Algo.run`

A different output on each shell should appear :)

## TODO:
- nodes discovery
