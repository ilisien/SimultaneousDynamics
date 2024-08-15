# Simultaneous Spring System Model

This is intended to demonstrate how optimization steps between timesteps in a spring system can allow for it to be more accurately modelled to practice assembling Julia packages.  
  
See docstrings within code for documentation -- WIP documentation for readme.  

# Steps to Get Running

1. Ensure Julia 1.10+ is installed on your system.  
2. Obtain git, I would recommend:  
    - By command line or otherwise directly [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)  
    - Through [Github Desktop](https://desktop.github.com/download/)  
    - or through the source control tab in [VSCode](https://code.visualstudio.com/)  
3. Clone this repo; via the command line this would look like navigating to an appropriate directory and running:  
    `$ git clone https://github.com/ilisien/SimultaneousDynamics.git`  
4. Navigate into the project directory. (`$ cd SimultaneousDynamics`)  
5. Start the Julia REPL: `$ julia`.  
6. Press `]` to get to the package manager; you should see something to the effect of `(@v1.10) pkg>`.  
7. Activate the project: `> activate .`; you should see:  
    ``Activating project at `/path/to/directory/SimultaneousDynamics` ``  
    `(SimultaneousDynamics) pkg> `  
8. Precompile and run the test simulation via `> test SimultaneousDynamics`. The `/test_output/raw_imgs` directories will be created for temporary images to be stored before the program finishes and stacks to `/test_output/simdyn_stack.tiff`.  
  
- To exit the package manager and the Julia REPL:  
    Press Backspace to exit the package manager.
    Run `> exit()`.


# Documentation

"""
    sqdist(p1::Pos, p2::Pos) -> Float64

Calculates the squared distance between two positions.

# Parameters
- `p1::Pos`: The first position.
- `p2::Pos`: The second position.

# Returns
- `Float64`: The squared distance between `p1` and `p2`.


"""
    sqrtdist(p1::Pos, p2::Pos) -> Float64

Calculates the Euclidean distance between two positions.

# Parameters
- `p1::Pos`: The first position.
- `p2::Pos`: The second position.

# Returns
- `Float64`: The Euclidean distance between `p1` and `p2`.


"""
Calculates the mean of the given vector.

# Methods

## `mean(v::Vector{Pos}) -> Float64`
Calculates the mean of the absolute values of the coordinates in a vector of positions.

- **Parameters**
  - `v::Vector{Pos}`: A vector of `Pos` objects, each with `x` and `y` coordinates.

- **Returns**
  - `Float64`: The mean of the absolute values of the coordinates.

## `mean(v::Vector{Float64}) -> Float64`
Calculates the mean of a vector of floating-point numbers.

- **Parameters**
  - `v::Vector{Float64}`: A vector of floating-point numbers.

- **Returns**
  - `Float64`: The mean of the values in the vector.


"""
    spring_force(p1::Pos, p2::Pos, k::Float64, L::Float64) -> Pos

Calculates the spring force exerted between two positions.

# Parameters
- `p1::Pos`: The first position.
- `p2::Pos`: The second position.
- `k::Float64`: The stiffness coefficient of the spring.
- `r::Float64`: The natural (relaxed) length of the spring.

# Returns
- `Pos`: The force exerted by the spring as a position.


"""
    optimization_step!(world::Types.World)

Performs an optimization step on the world to update the positions and velocities of the nodes.

# Parameters
- `world::Types.World`: The world containing nodes and springs to be optimized.


"""
    step!(world::Types.World)

Performs a simulation step on the world to update the positions and velocities of the nodes based on the forces applied.

# Parameters
- `world::Types.World`: The world containing nodes and springs to be simulated.


"""
	mutable struct Pos

Represents a set of x and y coordinates.

# Fields
- `x::Float64`: The x-coordinate in the set.
- `y::Float64`: The y-coordinate in the set.


"""
	Base.:+(a::Pos, b::Pos) -> Pos

Adds two `Pos` structures by summing their x and y values.

# Parameters
- `a::Pos`: The first position.
- `b::Pos`: The second position.

# Returns
- `Pos`: A new `Pos` structure with summed coordinates.


"""
	Base.:-(a::Pos,b::Pos) -> Pos

Subtracts the coordinates of one `Pos` structure from another.

# Parameters
- `a::Pos`: The position to subtract from.
- `b::Pos`: The position to subtract.

# Returns
- `Pos`: A new `Pos` structure with the difference of the coordinates.


"""
    Base.:*(p::Pos, scalar::Float64) -> Pos

Multiplies the coordinates of a `Pos` structure by a scalar value.

# Parameters
- `p::Pos`: The position to scale.
- `scalar::Float64`: The scalar value.

# Returns
- `Pos`: A new `Pos` structure with scaled coordinates.


"""
    mutable struct Node

Represents a node in the spring system.

# Fields
- `position::Pos`: The current position of the node.
- `velocity::Pos`: The current velocity of the node.
- `opt_position::Pos`: The optimized position of the node after an optimization step.
- `fixed::Bool`: Indicates whether the node is fixed in place (cannot move).
- `ext_force::Pos`: The external force applied to the node.

# Constructors
- `Node(position::Pos; velocity::Pos=Pos(0.0, 0.0), opt_position::Pos=Pos(0.0, 0.0), fixed::Bool=false, ext_force::Pos=Pos(0.0, 0.0))`: Create a `Node` with optional default values for `velocity`, `opt_position`, `fixed`, and `ext_force`.


"""
    mutable struct Spring

Represents a spring connecting two nodes.

# Fields
- `connections::Tuple`: A tuple of two integers indicating the indices of the connected nodes.
- `stiffness::Float64`: The stiffness coefficient of the spring.
- `relax_length::Float64`: The natural (relaxed) length of the spring.


"""
    mutable struct World

Represents the entire simulation world.

# Fields
- `nodes::Vector{Node}`: A vector containing all the nodes in the simulation.
- `springs::Vector{Spring}`: A vector containing all the springs in the simulation.
- `optimization_threshold::Float64`: A threshold value for determining when to stop optimizing the node positions.
- `timestep_length::Float64`: The length of each simulation timestep.
- `drag::Float64`: A drag coefficient to simulate resistance in the system.


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
    create_image_stack(image_paths::Vector{String}, output_path::String, delete_after::Bool=false)

Stacks a series of images into a single 3D image and saves it to the specified output path. Optionally, deletes the original images after saving the stack.

# Arguments
- `image_paths::Vector{String}`: A vector of file paths to the images to be stacked. Each path should be a string representing the location of an image file.
- `output_path::String`: The file path where the stacked image will be saved. This should be a string representing the desired output location and filename.
- `delete_after::Bool`: A boolean flag indicating whether the original images should be deleted after stacking. Defaults to `false`.

