@testitem "has_edge agrees with the SimpleGraph conversion" begin

import Graphs
using VNGraphs

for i in 1:20
    g = Graphs.random_regular_graph(6, 3)
    vng = VNGraph(g)
    for s in 1:6, d in 1:6
        @test Graphs.has_edge(vng, s, d) == Graphs.has_edge(g, s, d)
    end
end

g = VNGraph(3)
Graphs.add_edge!(g, Graphs.SimpleEdge(1, 2))
@test Graphs.has_edge(g, 1, 2)
@test !Graphs.has_edge(g, 2, 3)
@test Graphs.has_edge(g, 1, 2) isa Bool
for (s, d) in ((0, 1), (1, 4), (4, 1), (1, 100))
    @test !Graphs.has_edge(g, s, d)
end

end
