using SimultaneousDynamics
using Test
using CairoMakie

@testset "SimultaneousDynamics.jl" begin
    num_sides = 25
    radius = 2.0
    stiffness = 3.0
    relaxed_length = 0.5
    nodes, springs = node_polygon(num_sides, radius, stiffness, relaxed_length)
    nodes[1].position.x = 4
    
    world = World(nodes, springs, 0.0001, 0.1, 0.2)
    for i in 1:100
        step!(world)

        fig = plot_world(world)

        CairoMakie.save("../test_output/raw_imgs/$(string(i, pad=4)).png", fig)
    end

    image_paths = ["../test_output/raw_imgs/$(string(i,pad=4)).png" for i in 1:100]
    output_path = "../test_output/simdyn_stack.tiff"
    create_image_stack(image_paths, output_path, true)
end