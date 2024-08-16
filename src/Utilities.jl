module Utilities

using ..Types
using Images, FileIO, FilePathsBase

export node_polygon, create_image_stack, node_line, update_readme_with_docstrings

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
    node_line(n_nodes::Int, length::Float64, k::Float64, r::Float64; angle::Float64=0.0) -> Tuple{Vector{Node}, Vector{Spring}}

Constructs a line of nodes connected by springs in a specified direction.

# Parameters
- `n_nodes::Int`: The number of nodes in the line.
- `length::Float64`: The total length of the line.
- `k::Float64`: The stiffness coefficient for the springs.
- `r::Float64`: The natural (relaxed) length of the springs.
- `angle::Float64=0.0`: The angle (in radians) of the line direction relative to the x-axis. Default is 0.0.

# Returns
- `Tuple{Vector{Node}, Vector{Spring}}`: A tuple containing a vector of `Node` structures representing each node, and a vector of `Spring` structures connecting the nodes.
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

"""
    update_readme_with_docstrings(src_dir::String, readme_path::String) -> Void

Updates a README file by extracting docstrings from Julia source files and converting them into markdown format.

# Parameters
- `src_dir::String`: The directory containing the Julia source files (.jl) from which to extract docstrings.
- `readme_path::String`: The path to the README file that will be updated with the extracted docstrings.

# Description
This function automates the process of updating a README file with documentation from Julia source files. It performs the following steps:

1. **Extract Docstrings**: Scans each `.jl` file in the specified source directory (`src_dir`) and extracts all docstrings encapsulated by `\"\"\"`.
   
2. **Convert to Markdown**: Converts the extracted docstrings into markdown format suitable for inclusion in a README file. The first line of the docstring is treated as the function signature and formatted as a markdown header.

3. **Update README**: Finds the `# Documentation` section in the specified README file (`readme_path`) and replaces it with the newly generated documentation. If the `# Documentation` section is not found, an error is raised.

# Returns
- `Void`: This function updates the README file in place and does not return any value.
"""
function update_readme_with_docstrings(src_dir::String, readme_path::String)
    # Function to extract docstrings from a file
    function extract_docstrings(file_path::String)
        docstrings = []
        current_docstring = ""
        inside_docstring = false

        for line in eachline(file_path)
            if startswith(strip(line), "\"\"\"")
                if inside_docstring
                    # End of docstring
                    push!(docstrings, current_docstring)
                    current_docstring = ""
                end
                inside_docstring = !inside_docstring
            elseif inside_docstring
                current_docstring *= line * "\n"
            end
        end

        return docstrings
    end

    # Function to convert a docstring to markdown
    function convert_docstring_to_markdown(docstring::String)
        lines = split(docstring, "\n")
        markdown = ""
        for i in eachindex(lines)
            line = strip(lines[i])
            if i == 1 && !isempty(line)
                # The first line is assumed to be the function definition
                markdown *= "## `" * line * "`\n"
            elseif startswith(line, "# ")
                # Convert h1 format to h3 format
                markdown *= "###" * lstrip(line, '#') * "\n"
            else
                markdown *= line * "\n"
            end
        end
        return markdown
    end

    # Function to update the README file
    function update_readme(docstrings::Vector{String})
        # Read the current README content
        readme_content = read(readme_path, String)

        # Find the index of the # Documentation section
        doc_section_start = findfirst(r"# Documentation", readme_content)[1]

        if doc_section_start === nothing
            error("# Documentation section not found in README.md")
        end

        # Extract the part before the # Documentation section
        before_doc_section = readme_content[1:doc_section_start-1]

        # Create the new documentation section
        documentation_section = "# Documentation\n\n"
        for docstring in docstrings
            documentation_section *= convert_docstring_to_markdown(docstring) * "\n"
        end

        # Combine everything and write back to the README
        new_readme_content = before_doc_section * documentation_section
        open(readme_path, "w") do f
            write(f, new_readme_content)
        end
    end

    # Find all Julia files in the src directory
    julia_files = filter(x -> endswith(x, ".jl"), readdir(src_dir, join=true))

    # Extract docstrings from all files
    all_docstrings = String[]
    for file in julia_files
        append!(all_docstrings, extract_docstrings(file))
    end

    # Update the README with the extracted docstrings
    update_readme(all_docstrings)

    println("README.md updated successfully.")
end

end
