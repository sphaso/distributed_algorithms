# P2C

Elixir implementation of the coloring algorithm in Chapter 2 of `Distributed Algorithms` by `Jukka Suomela`.    
In contrast from P3C in Chapter 1, the graph can only be a path for the algorithm to make sense.

## How to use

- Open as many shells as you fancy
- Go to the project's directory
- run on each shell: `iex --sname {DISTINCT_NAME} --cookie {SECRET} -S mix` where `{DISTINCT_NAME}` is a distinct string for each shell but `{SECRET}` is the same
- connect each iex shell with `Node.connect :{DISTINCT_NAME}@{HOST}`, the full name corresponds to the iex prompt    
- IMPORTANT: disconnect non-adjacent nodes (you'll have to decide how the shells correspond to the nodes). By default connected nodes form an equivalence relationship!
- run on each iex shell `P2C.Algo.run`
- jump up and down if non-adjacent nodes\shells have the same color!

e.g.

`iex --sname foo --cookie secret -S mix`          
`iex --sname bar --cookie secret -S mix`       
`iex --sname star --cookie secret -S mix`       
`iex(foo@localhost)1> Node.connect :bar@localhost`        
`iex(bar@localhost)1> Node.connect :star@localhost`        
`iex(foo@localhost)2> Node.disconnect :star@localhost`

All three shells are connected in a path! foo <-> bar <-> star    

`iex(foo@localhost)3> P3C.Algo.run`         
`iex(bar@localhost)1> P3C.Algo.run`         
`iex(star@localhost)1> P3C.Algo.run`

Foo and Star should display "2", Bar "1".
