# 3-Stage Planetary Gearbox (OpenSCAD Design)

This repository contains the OpenSCAD design files for a compact 3-stage planetary gearbox, intended for applications like a quadruped robot leg. The design prioritizes modularity and parameterization, allowing for easy adjustments to gear ratios, dimensions, and clearances for 3D printing.

## Project Goal

The primary goal of this project is to develop a functional and printable 3-stage planetary gearbox that fits within specific dimensional constraints (e.g., 75mm diameter, 25mm height for the main housing) and provides a desired gear reduction.

## Current Status

The core gear, carrier, and initial housing modules are developed and parameterized. The assembly logic for stacking three stages is in place, and preliminary fit within the target dimensions has been achieved.

## OpenSCAD Files Structure

The design is organized into the `CAD/modules/` directory:

-   `_helper.scad`: Global parameters (gear module, teeth counts, clearances, heights) and common helper functions. This is the central control file for key dimensions.
-   `gear_module.scad`: Module for generating different types of involute gears (sun, planet, ring) with custom bores. Leverages `MCAD/involute_gears.scad`.
-   `carrier_module.scad`: Module for generating planetary carriers, including planet pin bosses and central bores for shafts.
-   `housing_parts.scad`: Modules for generating housing components, including the base, lid, planet pin supports, and the integrated ring gear profiles. This file now contains the `create_complete_housing` module for the main casing.
-   `gearbox_main.scad`: The main assembly file that combines all modules to build the complete 3-stage gearbox. This is the file you typically render.

## How to View/Modify

1.  **Install OpenSCAD:** Download and install OpenSCAD from [openscad.org](https://www.openscad.org/).
2.  **Clone this Repository:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git](https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git)
    cd YOUR_REPO_NAME
    ```
3.  **Open `CAD/modules/gearbox_main.scad`** in OpenSCAD.
4.  **Adjust Parameters:** Modify variables in `CAD/modules/_helper.scad` to customize the gearbox.
5.  **Render:** Press `F5` for a quick preview or `F6` for a full render (required for STL export).

## Prototyping Ready To-Do List

This section outlines the remaining tasks to make the gearbox design truly prototyping-ready for 3D printing and assembly.

### I. Model Refinement & Verification

-   [ ] **Detailed Clearance Review:**
    -   [ ] Re-evaluate `radial_clearance_shaft_bore` and `axial_clearance_per_stage` for all interfaces. Print small test pieces (e.g., a shaft and a bore, a gear and a flat surface) to determine optimal clearances for your specific 3D printer and material.
    -   [ ] Verify gear meshing visually in OpenSCAD (it won't simulate, but check for obvious interference/excessive backlash).
-   [ ] **Stress/Strength Considerations:**
    -   [ ] Revisit `gear_height` and `ring_outer_rim_thickness`. While fitting the 25mm constraint, ensure sufficient material thickness for printed part strength. Consider adding fillets to sharp internal corners for strength
