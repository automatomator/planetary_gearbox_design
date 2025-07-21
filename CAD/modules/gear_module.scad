// CAD/modules/gear_module.scad

// GLOBAL NOTE FOR PREVIEW PERFORMANCE:
// For faster previews (F5), especially with the ring gear, you can temporarily
// override '$fn' globally at the very top of your main OpenSCAD file (the one that calls this module).
// For example: '$fn = 24;' (a very low value for quick iteration).
// The explicit $fn values below will override this global setting for specific primitives.

// IMPORTANT CHANGE: Using 'mcad-master/involute_gears.scad' from the 'lib' folder.
// Path from CAD/modules to lib/MCAD: ../../lib/MCAD/
use <../../lib/MCAD-master/involute_gears.scad>; 

// Import our helper functions and global parameters
// The helper file is in the same 'modules' folder
include <_helper.scad>; 

// =======================================================
// Helper Module for Recursive Cutter Generation (for internal gears)
// =======================================================

/*
 * Module: recursive_gear_cutters(num_cutters, current_angle, angle_step, cutter_center_dist, cutter_params)
 * Description: Recursively generates a union of 'num_cutters' gear shapes, rotated around a central point.
 * Arguments:
 * num_cutters: The number of cutters to generate in this recursive call.
 * current_angle: The starting angle for the first cutter in this call.
 * angle_step: The angle increment between each cutter.
 * cutter_center_dist: Radial distance from origin for each cutter.
 * cutter_params: A list containing all parameters needed for the 'gear' module cutter.
 * (Specifically, cutter_params[12] is the $fn value for the gear cutter)
 * [number_of_teeth, diametral_pitch, pressure_angle, gear_thickness, bore_diameter,
 * rim_thickness, hub_thickness, spokes, circles, backlash, twist, flat, fn_value]
 */
module recursive_gear_cutters(num_cutters, current_angle, angle_step, cutter_center_dist, cutter_params) {
    if (num_cutters > 0) { // Only proceed if there are cutters to generate
        if (num_cutters == 1) {
            // Base case: generate a single cutter
            translate([cutter_center_dist, 0, 0]) {
                rotate([0, 0, current_angle]) { // Apply individual cutter's alignment rotation
                    // Unpack cutter_params list for the 'gear' module
                    gear(
                        number_of_teeth = cutter_params[0],
                        diametral_pitch = cutter_params[1],
                        pressure_angle = cutter_params[2],
                        gear_thickness = cutter_params[3],
                        bore_diameter = cutter_params[4],
                        rim_thickness = cutter_params[5],
                        hub_thickness = cutter_params[6],
                        spokes = cutter_params[7],
                        circles = cutter_params[8],
                        backlash = cutter_params[9],
                        twist = cutter_params[10],
                        flat = cutter_params[11],
                        $fn = cutter_params[12]
                    );
                }
            }
        } else {
            // Recursive step: Divide and Conquer
            half_cutters = floor(num_cutters / 2);
            
            union() {
                // Generate the first half of cutters
                recursive_gear_cutters(
                    half_cutters, 
                    current_angle, 
                    angle_step, 
                    cutter_center_dist, 
                    cutter_params
                );

                // Rotate and generate the second half of cutters
                rotate([0, 0, half_cutters * angle_step]) {
                    recursive_gear_cutters(
                        num_cutters - half_cutters, 
                        current_angle, 
                        angle_step, 
                        cutter_center_dist, 
                        cutter_params
                    );
                }
            }
        }
    }
    // If num_cutters is 0, the module simply generates no geometry, which is correct.
}


// =======================================================
// Gear Generation Module using YOUR involute_gears.scad 'gear' module
// =======================================================

/*
 * Module: create_gear(gear_type, teeth_count, gear_module_val, height_val, bore_d)
 * Description: Generates a complete gear (sun, planet, or manually-toothed ring) using YOUR involute_gears.scad 'gear' module.
 * Arguments:
 * gear_type: "sun", "planet", or "ring"
 * teeth_count: Number of teeth
 * gear_module_val: The module of the gear
 * height_val: Face width of the gear
 * bore_d: Diameter of the central bore hole
 */
module create_gear(gear_type, teeth_count, gear_module_val, height_val, bore_d=0) {

    // Calculate diametral_pitch from module for YOUR 'gear' module
    diametral_pitch_val = 1 / gear_module_val;

    // --- External Gears (Sun & Planet) ---
    if (gear_type == "sun" || gear_type == "planet") {
        difference() {
            // 1. Create the gear as a solid object (no bore)
            gear(
                number_of_teeth = teeth_count,
                diametral_pitch = diametral_pitch_val,
                pressure_angle = pressure_angle_deg,
                gear_thickness = height_val,
                bore_diameter = 0, // Explicitly set bore to 0 for a solid gear
                // Disable other optional features for a simple solid gear - IMPORTANT to match your MCAD version
                // If your MCAD version of gear() does not support these, remove them or comment them out.
                rim_thickness = 0, 
                rim_width = 0, 
                hub_thickness = 0, 
                hub_diameter = 0, 
                spokes = 0, 
                circles = 0, 
                backlash = 0, 
                twist = 0, 
                flat = false, 
                $fn = DEFAULT_FN 
            );
            // 2. Subtract the bore cylinder separately
            // This ensures consistent bore behavior regardless of MCAD gear() module's bore handling.
            cylinder(
                h = height_val + 2*0.1, // Slightly taller than gear_height for clean cut
                d = bore_d + (2*radial_clearance_shaft_bore), // Apply desired bore diameter with clearance
                center = true, // Ensure the cylinder is centered on the gear
                $fn = DEFAULT_FN 
            );
        }
    }
    // --- Internal (Ring) Gear - Manual Tooth Cutting (Option 2) ---
    else if (gear_type == "ring") {
        echo("NOTE: Generating 'toothed' ring gear using boolean difference (Option 2).");
        echo("WARNING: This is an approximation of an internal gear profile and is computationally intensive.");
        echo("HINT: For faster previews, temporarily set '$fn=32;' or '$fn=16;' at the top of your OpenSCAD script.");

        // Define parameters for the ring gear based on the provided teeth_count and module
        ring_pitch_diameter = pitch_diameter(teeth_count, gear_module_val);
        
        // The outer diameter of the solid cylinder from which the internal teeth will be cut.
        // This should be the theoretical "root diameter" of an internal gear (which is Pitch + 2*Dedendum for an external gear)
        // plus some wall thickness for the outer rim of the ring gear.
        ring_outer_rim_thickness = 4; // Example: 4mm thick solid wall for the ring gear
        ring_solid_body_diameter = ring_pitch_diameter + (2 * dedendum(gear_module_val)) + (2 * ring_outer_rim_thickness);

        // Parameters for the "cutter" (which is effectively a planet gear that meshes with the ring)
        planet_teeth_for_cutter = planet_teeth; // Use the actual planet gear teeth count for the cutter
        planet_pitch_diameter_for_cutter = pitch_diameter(planet_teeth_for_cutter, gear_module_val);

        // Calculate the center distance for the cutter relative to the ring gear's center.
        // For meshing an internal gear (Ring) with an external gear (Planet): C = (R_pitch - P_pitch) / 2
        cutter_center_distance = (ring_pitch_diameter - planet_pitch_diameter_for_cutter) / 2;

        // Angle for aligning the cutter's tooth space for cutting
        // This aligns a tooth of the cutter to cut a space in the ring gear.
        cutter_alignment_angle = 0.5 * 360 / planet_teeth_for_cutter;

        // Store cutter parameters in a list to pass to the recursive module
        // Ensure these match the parameters expected by your 'gear' module exactly.
        cutter_params = [
            planet_teeth_for_cutter,
            diametral_pitch_val,
            pressure_angle_deg,
            height_val + 2*0.1, // Slightly taller for clean cut
            0, // bore_diameter (bore of the cutter itself is irrelevant for cutting)
            0, 0, 0, 0, // rim_thickness, hub_thickness, spokes, circles (disabled for cutter)
            0, 0, false, // backlash, twist, flat
            DEFAULT_FN // $fn for individual cutter elements - balanced for performance/quality
        ];

        difference() {
            // 1. The main solid body of the ring gear, large enough to contain all teeth and the outer rim.
            cylinder(h=height_val, d=ring_solid_body_diameter, $fn=DEFAULT_FN); 

            // 2. Union of all cutting tools (recursive cutters and the central bore)
            union() {
                // Cut the central inner bore of the ring gear.
                // This bore allows the sun gear (or carrier components) to pass through.
                // It needs to clear the outside diameter of the sun gear plus space for carrier/housing.
                ring_central_bore_diameter = outside_diameter(sun_teeth, gear_module_value) + (2 * radial_clearance_shaft_bore) + (gear_module_value * 2); 
                cylinder(h=height_val + 2*0.1, d=ring_central_bore_diameter, $fn=DEFAULT_FN); 

                // Call the recursive cutter module to generate all planet gear cutters
                recursive_gear_cutters(
                    teeth_count,              // Total number of cutters (equal to ring teeth)
                    cutter_alignment_angle,   // Initial angle for the first cutter's alignment
                    360 / teeth_count,        // Angle step for positioning each cutter instance
                    cutter_center_distance,   // Radial distance from origin for each cutter
                    cutter_params             // List of parameters for the 'gear' module cutter
                );
            }
        }
    }
}

// =======================================================
// Debugging/Testing Section - Now generates 3 gears!
// Uncomment a block to test the gear in isolation
// =======================================================

/*
// Test a Sun Gear
color("red") create_gear(gear_type="sun", teeth_count=sun_teeth, gear_module_val=gear_module_value, height_val=gear_height, bore_d=motor_shaft_diameter);



// Test a Planet Gear
translate([30,0,0]) color("green") create_gear(gear_type="planet", teeth_count=planet_teeth, gear_module_val=gear_module_value, height_val=gear_height, bore_d=planet_pin_diameter);



// Test a Ring Gear (manually toothed representation)
translate([0,30,0]) color("blue") create_gear(gear_type="ring", teeth_count=ring_teeth, gear_module_val=gear_module_value, height_val=gear_height);
*/