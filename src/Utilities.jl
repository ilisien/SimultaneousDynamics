module Utilities

using ..Types
using Images, FileIO, FilePathsBase

export node_polygon, create_image_stack, node_line, update_readme_with_docs

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
        angle = 2 * π * (i - 1) / num_sides
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

"""
Constructs a line of nodes connected by springs in a specified direction.

# Arguments
- `n_nodes::Int`: Number of nodes in the line.
- `length::Float64`: Total length of the line.
- `k::Float64`: Spring stiffness coefficient.
- `r::Float64`: Rest length of the spring.
- `angle::Float64=0.0`: Angle (in radians) of the line direction relative to the x-axis. Default is 0.0.

# Returns
- `nodes`: Array of `Node` objects representing each node.
- `springs`: Array of `Spring` objects connecting the nodes.

Each node is positioned along the line according to its index and the total length,
with springs connecting adjacent nodes.
"""
function node_line(n_nodes::Int, length::Float64, k::Float64, r::Float64; angle::Float64=0.0)
    nodes = []
    for i in 1:n_nodes
        x = (i * length / n_nodes) * cos(angle)
        y = (i * length / n_nodes) * sin(angle)
        push!(nodes, Node(Pos(x, y)))
    end

    springs = []
    for i in 1:(n_nodes-1)
        push!(springs, Spring((i, i + 1), k, r))
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
function create_image_stack(image_paths::Vector{String}, output_path::String, delete_after::Bool=false)
    images = [load(img) for img in image_paths]
    save(output_path, cat(images..., dims=3))

    if delete_after
        rm.(image_paths)
    end
end

function extract_docstrings_from_file(file::String)
    docstrings = String[]
    function_name = ""
    in_docstring = false
    docstring_buffer = IOBuffer()

    open(file, "r") do io
        for line in eachline(io)
            if startswith(line, "\"\"\"")
                if in_docstring
                    in_docstring = false
                    full_docstring = String(take!(docstring_buffer))
                    # Extract the first line to use as the function signature
                    lines = split(full_docstring, "\n")
                    if !isempty(lines) && function_name != ""
                        header = "## $function_name\n"
                        content = join(lines[2:end], "\n")
                        # Convert existing headers to H3 format
                        content = replace(content, r"# (\w+)" => s -> "### " * s[2:end])
                        push!(docstrings, header * content)
                    end
                else
                    in_docstring = true
                    write(docstring_buffer, line[4:end] * "\n")  # Strip the initial triple quotes
                end
            elseif startswith(line, "function")
                function_name = strip(line)
            elseif in_docstring
                write(docstring_buffer, line * "\n")
            end
        end
    end
    return docstrings
end

function extract_docstrings_from_src(src_dir::String)
    docstrings = String[]
    for (root, _, files) in walkdir(src_dir)
        for file in files
            if endswith(file, ".jl")
                file_path = joinpath(root, file)
                append!(docstrings, extract_docstrings_from_file(file_path))
            end
        end
    end
    return join(docstrings, "\n\n")
end

function update_readme_with_docs(src_dir::String, readme_path::String)
    docstrings = extract_docstrings_from_src(src_dir)

    if docstrings == ""
        println("No docstrings found.")
        return
    end

    readme_content = read(readme_path, String)

    # Regex to find the Documentation section
    doc_section_regex = r"(?s)(# Documentation\n)(.*?)(\n#|\$)"

    if occursin(doc_section_regex, readme_content)
        readme_content = replace(readme_content, doc_section_regex) do match
            "# Documentation\n\n" * docstrings * "\n\n" * match.match[3]
        end
    else
        # If no Documentation section exists, add it at the end
        readme_content *= "\n\n# Documentation\n\n" * docstrings * "\n"
    end

    write(readme_path, readme_content)
    println("README.md updated with documentation.")
end

end
