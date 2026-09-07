@testitem "Mutation matches the SimpleGraph contract" begin

import Graphs
using VNGraphs

g = VNGraph(4)
@test Graphs.add_edge!(g, 1, 2) isa Bool
@test Graphs.add_edge!(g, 1, 3)
@test !Graphs.add_edge!(g, 1, 3)
@test Graphs.ne(g) == 2

for (s, d) in ((0, 1), (1, 0), (1, 5), (5, 1), (1, 100))
    @test !Graphs.add_edge!(g, s, d)
    @test !Graphs.rem_edge!(g, s, d)
end
@test Graphs.ne(g) == 2
@test Graphs.nv(g) == 4
@test Graphs.SimpleGraph(g) == Graphs.SimpleGraph(VNGraph(Graphs.SimpleGraph(g)))

@test Graphs.rem_edge!(g, 1, 3)
@test !Graphs.rem_edge!(g, 1, 3)
@test Graphs.ne(g) == 1

h = VNGraph(2)
@test Graphs.add_vertex!(h)
@test Graphs.nv(h) == 3
@test Graphs.add_edge!(h, 1, 3)
expected = Graphs.SimpleGraph(3)
Graphs.add_edge!(expected, 1, 3)
@test Graphs.SimpleGraph(h) == expected

for i in 1:20
    ref = Graphs.random_regular_graph(8, 3)
    built = VNGraph(8)
    for e in Graphs.edges(ref)
        @test Graphs.add_edge!(built, Graphs.src(e), Graphs.dst(e))
    end
    @test Graphs.ne(built) == Graphs.ne(ref)
    @test Graphs.SimpleGraph(built) == ref
    e1 = first(Graphs.edges(ref))
    @test Graphs.rem_edge!(built, Graphs.src(e1), Graphs.dst(e1))
    @test Graphs.ne(built) == Graphs.ne(ref) - 1
    after = copy(ref)
    Graphs.rem_edge!(after, e1)
    @test Graphs.SimpleGraph(built) == after
end

loop = VNGraph(3)
@test Graphs.add_edge!(loop, 2, 2)
@test Graphs.ne(loop) == 1
@test Graphs.rem_edge!(loop, 2, 2)
@test Graphs.ne(loop) == 0
@test !Graphs.rem_edge!(loop, 2, 2)

end
