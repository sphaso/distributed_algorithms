# Counting

Elixir implementation of Exercise 1, Chapter 2 of `Distributed Algorithms` by `Jukka Suomela`.    
```
We are given a path with some unknown number of nodes.          
All nodes have to stop and output n, the number of nodes.       
Design a deterministic distributed algorithm that solves the counting problem in time O(n).        
You can assume that the nodes have unique identifiers.
```

## How to use

- Open as many shells as you fancy
- Go to the project's directory
- run on each shell: `iex --sname {DISTINCT_NAME} --cookie {SECRET} -S mix` where `{DISTINCT_NAME}` is a distinct string for each shell but `{SECRET}` is the same
- connect each iex shell with `Node.connect :{DISTINCT_NAME}@{HOST}`, the full name corresponds to the iex prompt    
- IMPORTANT: disconnect non-adjacent nodes (you'll have to decide how the shells correspond to the nodes). By default connected nodes form an equivalence relation!
- run on each iex shell `Counting.Algo.run`. Running the command on one of the endpoint is enough, this is just to demonstrate that it won't matter where the code is executed
- jump up and down if the output is the number of shells!

e.g.

`iex --sname foo --cookie secret -S mix`          
`iex --sname bar --cookie secret -S mix`       
`iex --sname star --cookie secret -S mix`       
`iex(foo@localhost)1> Node.connect :bar@localhost`        
`iex(bar@localhost)1> Node.connect :star@localhost`        
`iex(foo@localhost)2> Node.disconnect :star@localhost`

All three shells are connected in a path! foo <-> bar <-> star    

`iex(foo@localhost)3> Counting.Algo.run`         
`3`

TODO:
- Allow for late nodes to connect at any point and output an updated number of nodes
