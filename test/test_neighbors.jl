@testitem "Neighbors agree with the SimpleGraph conversion" begin

import Graphs
import Random
using VNGraphs

for i in 1:20
    g = Graphs.random_regular_graph(10, 3)
    vng = VNGraph(g)
    for v in Graphs.vertices(g)
        @test Graphs.outneighbors(vng, v) == Graphs.outneighbors(g, v)
        @test Graphs.inneighbors(vng, v) == Graphs.inneighbors(g, v)
        @test issorted(Graphs.outneighbors(vng, v))
    end
    @test Graphs.degree(vng) == Graphs.degree(g)
    @test Graphs.connected_components(vng) == Graphs.connected_components(g)
    @test Graphs.gdistances(vng, 1) == Graphs.gdistances(g, 1)
    @test Graphs.is_connected(vng) == Graphs.is_connected(g)
end

g = VNGraph(4)
for d in (4, 3, 2)
    Graphs.add_edge!(g, 1, d)
end
@test Graphs.outneighbors(g, 1) == [2, 3, 4]
@test eltype(Graphs.outneighbors(g, 1)) == eltype(g)
@test isempty(Graphs.outneighbors(VNGraph(3), 2))
for v in (-1, 0, 5)
    @test_throws BoundsError Graphs.outneighbors(g, v)
    @test_throws BoundsError Graphs.inneighbors(g, v)
end

loop = VNGraph(3)
Graphs.add_edge!(loop, 1, 1)
Graphs.add_edge!(loop, 1, 2)
sloop = Graphs.SimpleGraph(3)
Graphs.add_edge!(sloop, 1, 1)
Graphs.add_edge!(sloop, 1, 2)
@test Graphs.outneighbors(loop, 1) == Graphs.outneighbors(sloop, 1)
@test Graphs.degree(loop, 1) == Graphs.degree(sloop, 1)

ref = Graphs.random_regular_graph(12, 4)
shuffled = VNGraph(12)
for e in Random.shuffle(collect(Graphs.edges(ref)))
    Graphs.add_edge!(shuffled, Graphs.src(e), Graphs.dst(e))
end
for v in Graphs.vertices(ref)
    @test Graphs.outneighbors(shuffled, v) == Graphs.outneighbors(ref, v)
end

end
