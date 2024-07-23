using SimultaneousDynamics
using Test

@testset "SimultaneousDynamics.jl" begin
    nodes = [
        Node(Pos(0.0, 0.0), Pos(0.0, 0.0), Pos(0.0,0.0)),
        Node(Pos(1.0, 0.0), Pos(0.0, 0.0), Pos(0.0,0.0)),
        Node(Pos(2.0, 0.0), Pos(0.0, 0.0), Pos(0.0,0.0)),
        Node(Pos(3.0, 0.0), Pos(0.0, 0.0), Pos(0.0,0.0)),
        Node(Pos(8.0, 0.0), Pos(0.0, 0.0), Pos(0.0,0.0)),
    ]

    springs = [
        Spring((1, 2), 1, 0.5),
        Spring((2, 3), 1, 0.5),
        Spring((3, 4), 1, 0.5),
        Spring((4, 5), 1, 0.5),
    ]

    world = World(nodes,springs,0.0001,0.1,0.2)
    for _ in 1:10000
        step!(world)

        for node in world.nodes
            println("Position: ($(node.position.x), $(node.position.y)), Velocity: ($(node.velocity.x), $(node.velocity.y))")
        end
        println("")
    end
end
