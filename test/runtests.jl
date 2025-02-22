using SimultaneousDynamics
using Test
using CairoMakie

@testset "SimultaneousDynamics.jl" begin
    imgs_path = "../test_output/raw_imgs"

    mkpath(imgs_path)
    nsteps = 10

    num_sides = 21
    radius = 2.0
    stiffness = 1.0
    relaxed_length = 0.0
    #nodes, springs = node_polygon(num_sides, radius, stiffness, relaxed_length)
    nodes, springs = node_line(7,3.0,stiffness,relaxed_length)

    nodes[7].ext_force = Pos(3.0,0.0) # set an external force in the positive x direction of 5.0
    nodes[1].fixed = true # set node 1 static
    #nodes[7].fixed = true # set node 1 static

    #nodes[10].fixed = true # set node 10 static
    
    world = World(nodes, springs, 1e-5, 0.25, 1.0)
    for i in 1:nsteps
        print("starting step $(string(i, pad=4)) | ")
        step!(world)
        print("stepped | ")

        fig = plot_world(world)
        print("plotted | ")

        CairoMakie.save(imgs_path * "/$(string(i, pad=4)).png", fig)
        println("saved | completed!!!!")
    end
    println("finished $nsteps steps!")

    image_paths = [imgs_path * "/$(string(i,pad=4)).png" for i in 1:nsteps]
    output_path = imgs_path * "/../simdyn_stack.tiff"

    print("stacking images ... ")
    create_image_stack(image_paths, output_path, false)
    println("completed!!!")
    println("see /test_output/simdyn_stack.tiff")
end
