@testitem "clique_number dispatches to very_nauty" begin

import Graphs
using VNGraphs

for (n, p) in ((10, 0.3), (15, 0.4), (20, 0.3), (25, 0.5), (12, 0.7), (18, 0.9))
    for t in 1:5
        g = Graphs.erdos_renyi(n, p)
        @test Graphs.clique_number(g, VNAlgorithm()) == Graphs.clique_number(g)
        @test Graphs.clique_number(VNGraph(g), VNAlgorithm()) == Graphs.clique_number(g)
    end
end

@test Graphs.clique_number(Graphs.complete_graph(6), VNAlgorithm()) == 6
@test Graphs.clique_number(Graphs.path_graph(4), VNAlgorithm()) == 2
@test Graphs.clique_number(Graphs.SimpleGraph(5), VNAlgorithm()) == 1
@test Graphs.clique_number(Graphs.SimpleGraph(1), VNAlgorithm()) == 1
@test Graphs.clique_number(Graphs.complete_graph(6), VNAlgorithm()) isa Int
@test_throws ArgumentError Graphs.clique_number(Graphs.SimpleDiGraph(3), VNAlgorithm())
@test Graphs.clique_number(Graphs.SimpleGraph(0), VNAlgorithm()) == 0

gs = [Graphs.erdos_renyi(30, 0.6) for _ in 1:4]
ref = [Graphs.clique_number(g) for g in gs]
agreed = Threads.Atomic{Int}(0)
Threads.@threads for k in 1:64
    i = mod1(k, 4)
    Graphs.clique_number(gs[i], VNAlgorithm()) == ref[i] && Threads.atomic_add!(agreed, 1)
end
@test agreed[] == 64

end
