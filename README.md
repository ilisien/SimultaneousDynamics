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
    Press '<-Backspace' to exit the package manager.
    Run `> exit()`.
