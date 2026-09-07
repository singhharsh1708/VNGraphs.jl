@testitem "edges agrees with the SimpleGraph conversion" begin

import Graphs
using VNGraphs

for i in 1:20
    g = Graphs.random_regular_graph(10, 3)
    vng = VNGraph(g)
    es = collect(Graphs.edges(vng))
    @test Tuple.(es) == Tuple.(collect(Graphs.edges(g)))
    @test issorted(Tuple.(es))
    @test length(es) == Graphs.ne(vng)
    @test length(Graphs.edges(vng)) == Graphs.ne(vng)
end

@test Graphs.edges(VNGraph(3)) isa Graphs.AbstractEdgeIter
@test eltype(Graphs.edges(VNGraph(3))) == Graphs.edgetype(VNGraph(3))
@test isempty(collect(Graphs.edges(VNGraph(0))))
@test isempty(collect(Graphs.edges(VNGraph(4))))
@test repr(Graphs.edges(VNGraph(4))) == "VNEdgeIter 0"

h = VNGraph(3)
Graphs.add_edge!(h, 1, 2)
Graphs.add_edge!(h, 1, 2)
@test length(collect(Graphs.edges(h))) == 1
@test Graphs.ne(h) == 1

g = VNGraph(3)
Graphs.add_edge!(g, 2, 2)
Graphs.add_edge!(g, 1, 3)
@test collect(Graphs.edges(g)) ==
    [Graphs.edgetype(g)(1, 3), Graphs.edgetype(g)(2, 2)]
@test length(Graphs.edges(g)) == Graphs.ne(g)

rg = VNGraph(Graphs.random_regular_graph(10, 3))
e1 = first(Graphs.edges(rg))
@test e1 in Graphs.edges(rg)
@test reverse(e1) in Graphs.edges(rg)
absent = first(setdiff(2:10, Graphs.outneighbors(rg, 1)))
@test !(Graphs.edgetype(rg)(1, absent) in Graphs.edges(rg))
@test !(Graphs.edgetype(rg)(1, 11) in Graphs.edges(rg))

end
