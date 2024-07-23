using SimultaneousDynamics
using Test
using CairoMakie

function create_polygon(num_sides::Int, radius::Float64)
    nodes = []
    for i in 1:num_sides
        angle = 2 * π * (i-1) / num_sides
        x = radius * cos(angle)
        y = radius * sin(angle)
        push!(nodes, Node(Pos(x, y), Pos(0.0, 0.0), Pos(0.0, 0.0)))
    end

    springs = []
    for i in 1:num_sides
        next_index = i % num_sides + 1
        push!(springs, Spring((i, next_index), 1.0, 0.1))
    end

    return nodes, springs
end

@testset "SimultaneousDynamics.jl" begin
    num_sides = 25
    radius = 2.0
    nodes, springs = create_polygon(num_sides, radius)
    nodes[1].position.x = 4
    
    world = World(nodes, springs, 0.0001, 0.1, 0.2)
    for i in 1:100
        step!(world)

        for node in world.nodes
            println("Position: ($(node.position.x), $(node.position.y)), Velocity: ($(node.velocity.x), $(node.velocity.y))")
        end
        println("")

        fig = plot_world(world)

        CairoMakie.save("$(string(i, pad=4)).png", fig)
    end
end