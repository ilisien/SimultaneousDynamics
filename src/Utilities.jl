module Utilities

using ..Types
using Images, FileIO, FilePathsBase

export node_polygon, create_image_stack, node_line

"""
    node_polygon(num_sides::Int, radius::Float64, k::Float64, r::Float64) -> Tuple{Vector{Node}, Vector{Spring}}

Generates a polygonal arrangement of nodes connected by springs.

# Parameters
- `num_sides::Int`: The number of sides (and nodes) of the polygon.
- `radius::Float64`: The radius of the circumscribed circle of the polygon.
- `k::Float64`: The stiffness coefficient for the springs.
- `r::Float64`: The natural (relaxed) length of the springs.

# Returns
- `Tuple{Vector{Node}, Vector{Spring}}`: A tuple containing a vector of `Node` structures and a vector of `Spring` structures that form the polygon.
"""
function node_polygon(num_sides::Int, radius::Float64, k::Float64, r::Float64)
    nodes = []
    for i in 1:num_sides
        angle = 2 * π * (i-1) / num_sides
        x = radius * cos(angle)
        y = radius * sin(angle)
        push!(nodes, Node(Pos(x, y)))
    end

    springs = []
    for i in 1:num_sides
        next_index = i % num_sides + 1
        push!(springs, Spring((i, next_index), k, r))
    end

    return nodes, springs
end

function node_line(n_nodes::Int,length::Float64,k::Float64,r::Float64;angle::Float64=0.0)
    nodes = []
    for i in 1:n_nodes
        x = (i*length/n_nodes)*cos(angle)
        y = (i*length/n_nodes)*sin(angle)
        push!(nodes, Node(Pos(x,y)))
    end

    springs = []
    for i in 1:(n_nodes-1)
        push!(springs,Spring((i,i+1), k, r))
    end

    return nodes, springs
end

"""
    create_image_stack(image_paths::Vector{String}, output_path::String, delete_after::Bool=false)

Stacks a series of images into a single 3D image and saves it to the specified output path. Optionally, deletes the original images after saving the stack.

# Arguments
- `image_paths::Vector{String}`: A vector of file paths to the images to be stacked. Each path should be a string representing the location of an image file.
- `output_path::String`: The file path where the stacked image will be saved. This should be a string representing the desired output location and filename.
- `delete_after::Bool`: A boolean flag indicating whether the original images should be deleted after stacking. Defaults to `false`.
"""
function create_image_stack(image_paths::Vector{String},output_path::String,delete_after::Bool=false)
    images = [load(img) for img in image_paths]
    save(output_path, cat(images ..., dims=3))
    
    if delete_after
        rm.(image_paths)
    end
end

end