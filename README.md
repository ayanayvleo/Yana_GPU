# YanaGPU — Milestone 2

YanaGPU is a simulation-first FPGA GPU learning project targeting the Artix-7
`xc7a35tcpg236-1` used by the Basys 3 board.

## Milestone 2: Vector register file and compact I/O

YanaGPU now contains eight internal 64-bit vector registers. Input vectors are
loaded eight bits at a time, the SIMD engine reads source registers, and its
64-bit result is written to a destination register. A selected 16-bit lane can
be inspected externally. This reduces the top-level interface from 133 ports to
51 ports so the design can be placed on the Basys 3-compatible FPGA package.

## Included foundation: Four-lane SIMD math

One instruction performs either addition or multiplication across four pairs of
8-bit numbers simultaneously. Each result is 16 bits wide.

```text
Lane 0: A0 op B0
Lane 1: A1 op B1
Lane 2: A2 op B2
Lane 3: A3 op B3
```

This is a parallel compute engine—the mathematical foundation of a GPU—not yet
a complete graphics card. Future milestones will add registers, instructions,
memory, multiple compute cores, and a simple rendering pipeline.

## Create the Vivado project

1. Open Vivado.
2. In the Tcl Console, change into the `YanaGPU/vivado` directory.
3. Run `source create_project.tcl`.
4. In the Flow Navigator, choose **Run Simulation → Run Behavioral Simulation**.

Expected final console message:

`YanaGPU milestone 1 passed all tests!`
