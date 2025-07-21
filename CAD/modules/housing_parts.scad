// CAD/modules/housing_parts.scad

// This file contains modules for the fixed components of the gearbox housing,
// including the top plate, bottom plate, and integrated ring gears.

// Import helper functions and global parameters
include <_helper.scad>;
// Import gear module to use its create_gear function for ring gears
include <gear_module.scad>;

// --- Housing Parameters ---
// Thickness of the top and bottom plates
top_bottom_plate_thickness = 2.5; // Example: 2.5mm for base and lid (Adjusted previously)

// Height available for the stages between the top and bottom plates
// Total gearbox height (25mm) - 2 * plate_thickness
inner_housing_height = 25 - (2 * top_bottom_plate_thickness);

// Internal diameter of the housing where the ring gears fit
housing_internal_diameter = ring_gear_housing_bore_diameter;

// Outer diameter of the housing
housing_outer_diameter = 75; //

// =======================================================
// Housing Component Modules (Helper Modules)
// These are internal helper modules, not meant to be called directly for final assembly.
// =======================================================

/*
 * Module: _get_ring_gear_cutter(z_offset)
 * Description: Generates a negative (cutting) shape for a single ring gear.
 * We use this to subtract the tooth profile from a solid housing wall.
 * It's essentially the *negative* of the ring gear, filling the space where the gear is not.
 */
module _get_ring_gear_cutter(z_offset) {
    // This needs to cut out the teeth and the central bore.
    // The create_gear("ring") module already uses a difference internally.
    // Here, we need to create a solid cylinder that is the outer boundary of the ring gear,
    // and then we will union the ring gear *cutters* (not the gear itself) from it.

    // A simple way for a housing is to take a solid cylinder, and then
    // subtract an external gear. The space left is the internal gear.
    
    // Instead of re-implementing the complex ring gear cutting logic here,
    // we'll rely on the 'create_gear("ring")' module to give us the tooth profile.
    // However, for boolean operations, it's often better to work with the 'cutters' directly.

    // Let's modify create_gear in gear_module.scad slightly to expose the cutter.
    // FOR NOW, we will use the existing create_gear("ring") as a negative object.
    // This is less robust than true cutter geometry but will work for initial integration.
    translate([0, 0, z_offset]) {
        // We need a negative of the *tooth profile* for the housing.
        // The 'create_gear("ring")' module produces the ring gear itself.
        // We want to subtract the *inverse* of that, or simply the gear itself
        // from a solid cylinder that represents the space where the internal gear will sit.

        // A better approach: Create a simple cylinder that covers the entire housing internal
        // diameter, and then subtract the outer profile of an external planet gear
        // at multiple rotations. This is what create_gear("ring") does internally.

        // For a seamless housing, we will create the entire housing shell as a solid,
        // and then cut the specific tooth profiles from it.
        
        // This 'cutter' is a temporary approach. We need the actual *tooth form* of the ring gear
        // which create_gear("ring") produces.
        // We will make the housing first, then subtract the negative of the ring gear's internal space.
        // Let's refine this in create_complete_housing directly.
        
        // Temporarily, this will be the space that the ring gear occupies.
        // We will combine these spaces and subtract from a solid housing.
        children(); // This module expects to be wrapped around content
    }
}


// =======================================================
// Main Housing Module
// =======================================================

/*
 * Module: create_complete_housing(output_shaft_d)
 * Description: Generates the entire 3-stage gearbox housing as a single, printable part.
 * It includes the base, lid, outer walls, and integrated ring gear tooth profiles.
 * output_shaft_d: Diameter of the final output shaft for the lid bore.
 */
module create_complete_housing(output_shaft_d) {
    // Define Z-offsets for the ring gears within the housing.
    // These should align with where the actual gears will sit.
    // Ring gears will be integrated into the housing's inner wall.
    // The bottom of the first ring gear sits on the base plate.
    stage1_ring_z = top_bottom_plate_thickness;

    // The gap between stages for the carrier and planets
    stage_vertical_gap = carrier_total_height + axial_clearance_per_stage; // Total height of a carrier layer

    stage2_ring_z = stage1_ring_z + stage_vertical_gap;
    stage3_ring_z = stage2_ring_z + stage_vertical_gap;

    // Define the overall solid body of the housing.
    // This will be a cylinder from base to top, with a central hole for shafts.
    // We'll then subtract the ring gear profiles and planet pin holes.
    difference() {
        union() {
            // 1. Main outer housing shell (from base to top)
            // This is a thick-walled cylinder. We'll cut out the internal spaces.
            cylinder(h = overall_gearbox_height, d = housing_outer_diameter, $fn = DEFAULT_FN);

            // 2. Solid material for the top and bottom plates (if not part of the main shell already)
            // If the main shell covers the full height, these might be redundant or for detailing.
            // For now, assume the cylinder covers this.

            // 3. Planet Pin Housing Supports (solid before holes are cut)
            // These run from the top of the base plate to the bottom of the lid.
            translate([0,0,top_bottom_plate_thickness]) { // Supports start on top of the base plate
                create_planet_pin_housing_supports(
                    num_planets = 3, // Assuming 3 planets per stage
                    planet_orbit_radius = planet_orbit_radius, // from _helper
                    support_height = overall_gearbox_height - (2 * top_bottom_plate_thickness) // Between plates
                );
            }
        }

        // --- Subtract all internal spaces ---
        union() {
            // 1. Central bore from bottom to top (for motor shaft and output shaft)
            // This needs to be wide enough to clear the largest shaft/hub that passes through.
            // Consider the sun gear's outside diameter for clearance.
            central_bore_diameter_through = max(motor_shaft_diameter, output_shaft_d) + (2 * radial_clearance_shaft_bore) + (gear_module_value * 2); // Add margin for sun gear clearance
            translate([0,0,-0.1]) { // Start slightly below base
                cylinder(h = overall_gearbox_height + 0.2, d = central_bore_diameter_through, $fn = DEFAULT_FN);
            }

            // 2. Inner cylindrical space where the rotating carriers and gears reside.
            // This space is basically from the inner diameter of the ring gears inward.
            // This needs to be slightly smaller than 'housing_internal_diameter' if you want a rim for the ring gears.
            // Let's create a cylindrical 'cavity' where the active gears will sit.
            // This cavity is slightly wider than the internal diameter of the ring gear teeth.
            // This is where the bulk of the rotating parts go.
            // The top and bottom plates will cover this, but the "middle" is hollow.
            translate([0,0,top_bottom_plate_thickness]) { // Starts above the base plate
                cylinder(h = overall_gearbox_height - (2 * top_bottom_plate_thickness),
                         d = housing_internal_diameter - (2 * ring_outer_rim_thickness) + (2 * radial_clearance_shaft_bore), // Make cavity slightly larger than gears
                         $fn = DEFAULT_FN);
            }


            // 3. Cut out the individual internal ring gear tooth profiles
            // We use the 'create_gear("ring")' module directly as the cutter.
            // It generates the geometry, and when subtracted, it leaves the inverse (the internal teeth).
            translate([0,0,-0.1]) { // Ensure cutter goes slightly below to ensure clean cut
                // Stage 1 Ring Gear Profile Cutout
                create_gear(gear_type="ring", teeth_count=ring_teeth, gear_module_val=gear_module_value, height_val=gear_height + 0.2); // Make cutter slightly taller
                // Move for next stage's cutter
                translate([0,0,stage_vertical_gap]) {
                    // Stage 2 Ring Gear Profile Cutout
                    create_gear(gear_type="ring", teeth_count=ring_teeth, gear_module_val=gear_module_value, height_val=gear_height + 0.2);
                    // Move for next stage's cutter
                    translate([0,0,stage_vertical_gap]) {
                        // Stage 3 Ring Gear Profile Cutout
                        create_gear(gear_type="ring", teeth_count=ring_teeth, gear_module_val=gear_module_value, height_val=gear_height + 0.2);
                    }
                }
            }


            // 4. Cut out the holes for the planet pins that run through the housing supports.
            // These holes need to go through the solid planet_pin_housing_supports.
            planet_pin_hole_diameter_cutter = planet_pin_diameter + (2*radial_clearance_shaft_bore);
            // This cutter needs to go from slightly below the bottom plate to slightly above the top plate.
            translate([0,0,-0.1]) {
                for (i = [0 : 3 - 1]) { // Assuming 3 planets per stage
                    rotate([0, 0, i * (360 / 3)]) {
                        translate([planet_orbit_radius, 0, 0]) {
                            cylinder(h = overall_gearbox_height + 0.2, d = planet_pin_hole_diameter_cutter, $fn = DEFAULT_FN);
                        }
                    }
                }
            }
        }
    }
}

// =======================================================
// Debugging/Testing Section - Housing Parts
// Uncomment a block to test the housing parts in isolation
// =======================================================

/*
// Test the complete housing
// You need to ensure overall_gearbox_height, planet_orbit_radius are accessible (defined in _helper or passed)
// For testing housing_parts directly, you might need to temporarily define some globals here:
// overall_gearbox_height = 25;
// sun_pitch_radius = pitch_diameter(sun_teeth, gear_module_value) / 2;
// planet_pitch_radius = pitch_diameter(planet_teeth, gear_module_value) / 2;
// planet_orbit_radius = sun_pitch_radius + planet_pitch_radius;
// carrier_plate_height = gear_height + axial_clearance_per_stage;
// carrier_boss_extension = 2;
// carrier_total_height = carrier_plate_height + carrier_boss_extension;
//
color("darkblue") create_complete_housing(output_shaft_d = 8);
*/