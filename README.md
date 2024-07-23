# simultaneous spring system model

this is intended to demonstrate how optimization steps between timesteps in a spring system can allow for it to be more accurately modelled

### model pseudo-code:
`function optimization_step(world):\
    for each node:\
        move node by timestep * node.velocity\
    for each node:\
        determine new velocity of node based on forces\
\
function step(world):\
    old_mean_velocity = 0\
    velocity_diff = 100\
    while velocity_diff > optimization_threshold:\
        optimization_step()\
        mean_velocity = mean(list_of_node_velocities)\
        velocity_diff = abs(mean_velocity-old_mean_velocity)\
        old_mean_velocity = mean_velocity\`

### model documentation:
Structures:\
    - `Pos`:\
        an x,y coordinate Struct\
        - `x`: the x coordinate\
        - `y`: the y coordinate\
    - `Node`:\
        the points that springs exert forces on and connect to\
        - `position`: a `Pos` object that represents the position of the node\
        - `velocity`: a `Pos` object that represents the velocity of the node\
    - `Spring`:\
        the spring object that exerts forces on connected nodes\
        - `connections`: a tuple of the indicies of connected node objects\
        - `stiffness`: the spring stiffness constant "k"\
        - `relax_length`: the length of the spring when it is exerting zero force on outside nodes\
    - `World`:\
        - `nodes`: a vector of the nodes in the simulated world\
        - `springs`: a vector of the springs in the simulated world\
        - `optimization_threshold`: the threshold for differences in maximum step-to-step velocity to decide optimization steps are done\
        - `timestep_length`: the length (in seconds) of a timestep\
        
