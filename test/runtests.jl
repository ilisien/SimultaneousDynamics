using SimultaneousDynamics
using Test

@testset "SimultaneousDynamics.jl" begin
    nodes = [
        Node(Pos(0.0, 0.0), Pos(0.0, 0.0), Pos(0.0,0.0)),
        Node(Pos(1.0, 0.0), Pos(0.0, 0.0),Pos(0.0,0.0))
    ]

    springs = [
        Spring((1, 2), 10.0, 0.5),
    ]

    world = World(nodes,springs,0.001,0.1,0.2)

    step!(world)

    for node in world.nodes
        println("Position: ($(node.position.x), $(node.position.y)), Velocity: ($(node.velocity.x), $(node.velocity.y))")
    end
end
