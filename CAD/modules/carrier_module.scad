// CAD/modules/carrier_module.scad

// Import helper functions and global parameters using a relative path
// The helper file is in the same 'modules' folder
include <_helper.scad>; 

// === Helper Module: _create_solid_carrier_and_bosses ===
// Generates the solid geometry of the carrier plate AND ALL ITS BOSSES.
// The bosses now have an extended height.
module _create_solid_carrier_and_bosses(num_planets, carrier_height, boss_extension_height, planet_pin_d, gear_module_value, planet_orbit_radius, planet_pitch_radius) {
    // Everything within this union() block will be combined into a single solid object.
    union() {
        // 1. Main carrier plate: This is a solid cylinder.
        // It starts exactly at Z=0 and extends upwards to 'carrier_height'.
        // Calculate max diameter needed for the carrier to contain all planets within its bounds.
        // This is the orbit radius + planet's outside radius + some margin.
        carrier_outer_diameter = (planet_orbit_radius * 2) + outside_diameter(planet_teeth, gear_module_value) + (gear_module_value * 2); // Add 2*module as margin
        
        cylinder(h = carrier_height, d = carrier_outer_diameter, center = false, $fn=DEFAULT_FN);

        // 2. Individual solid bosses for planet pins: These are also solid cylinders.
        // Each boss cylinder now extends from Z=0 to (carrier_height + boss_extension_height).
        // This makes them protrude above the main carrier plate.
        // Reconsidering boss diameter for compactness and strength.
        // Let's use a wall thickness around the pin.
        boss_wall_thickness = 2.5; // Example: 2.5mm material around the pin for strength
        boss_diameter = planet_pin_d + (2 * boss_wall_thickness);

        for (i = [0 : num_planets - 1]) {
            rotate([0, 0, i * (360 / num_planets)]) {
                translate([planet_orbit_radius, 0, 0]) { // Move to planet position
                    // Boss height is now carrier_height + additional_boss_height
                    cylinder(h = carrier_height + boss_extension_height, d = boss_diameter, center = false, $fn=DEFAULT_FN);
                }
            }
        }
    }
}

// === Helper Module: _create_all_bore_cutters ===
// Generates the cutting tools (cylinders) for the central bore and planet pin holes.
// The cutters are now taller to go through the extended bosses.
module _create_all_bore_cutters(num_planets, carrier_height, boss_extension_height, planet_pin_d, sun_gear_bore_d, output_shaft_d, radial_clearance_shaft_bore, planet_orbit_radius) {
    // Everything within this union() block will be combined into a single cutting tool.
    union() {
        // 1. Central bore cutter: A cylinder to cut the central hole.
        // Its height is adjusted to go through the entire combined carrier and boss height.
        translate([0,0,-0.5]) { // Shift cutter down to ensure cut from below Z=0
            cylinder(h = carrier_height + boss_extension_height + 1.0, // Total height of carrier + boss extension + overlap
                     d = max(sun_gear_bore_d + (2*radial_clearance_shaft_bore), output_shaft_d + (2*radial_clearance_shaft_bore)),
                     center = false, // Starts at Z=-0.5, extends upwards
                     $fn=DEFAULT_FN);
        }

        // 2. Planet pin hole cutters: Cylinders to cut holes through the bosses.
        // Their height is also adjusted for a clear through-cut of the extended bosses.
        for (i = [0 : num_planets - 1]) {
            rotate([0, 0, i * (360 / num_planets)]) {
                translate([planet_orbit_radius, 0, 0]) { // Move to planet position for the cutter
                    cylinder(h = carrier_height + boss_extension_height + 1.0, // Taller to ensure through-cut of extended boss
                             d = planet_pin_d + (2*radial_clearance_shaft_bore), // Add clearance for fit
                             center = false, 
                             $fn=DEFAULT_FN);
                }
            }
        }
    }
}


/*
 * Module: create_planetary_carrier()
 * Description: Generates a basic planetary gear carrier by composing helper modules.
 * This carrier will hold the planet gears and rotate around the sun gear.
 * Arguments:
 * num_planets: The number of planet gears in the setup.
 * carrier_height: The height/thickness of the carrier body.
 * boss_extension_height: The additional height the bosses extend beyond the main carrier plate.
 * planet_pin_d: Diameter of the pins that hold the planet gears.
 * sun_gear_bore_d: The diameter of the central bore that clears the sun gear's shaft.
 * output_shaft_d: The diameter of the central bore for the carrier's output shaft (if applicable).
 */
module create_planetary_carrier(num_planets, carrier_height, boss_extension_height, planet_pin_d, sun_gear_bore_d, output_shaft_d) {

    // Calculate the pitch radius of the sun gear
    sun_pitch_radius = pitch_diameter(sun_teeth, gear_module_value) / 2;

    // Calculate the pitch radius of a planet gear
    planet_pitch_radius = pitch_diameter(planet_teeth, gear_module_value) / 2;

    // The distance from the center of the sun gear to the center of any planet gear
    // This is the radius of the planet gear orbit.
    planet_orbit_radius = sun_pitch_radius + planet_pitch_radius;

    // === Final Step: Perform the DIFFERENCE operation ===
    // This takes the combined solid carrier+extended bosses and subtracts the combined hole cutters.
    difference() {
        // The first argument to difference() is the solid object we want to cut FROM.
        // This calls the helper module that UNIONS the carrier base and the boss cylinders.
        _create_solid_carrier_and_bosses(
            num_planets, 
            carrier_height, 
            boss_extension_height, 
            planet_pin_d, 
            gear_module_value, 
            planet_orbit_radius,
            planet_pitch_radius
        );
        // The second argument to difference() is the cutting object (the holes).
        // This calls the helper module that UNIONS all the hole cylinders.
        _create_all_bore_cutters(
            num_planets, 
            carrier_height, 
            boss_extension_height, 
            planet_pin_d, 
            sun_gear_bore_d, 
            output_shaft_d, 
            radial_clearance_shaft_bore, 
            planet_orbit_radius
        );
    }
}


// =======================================================
// Debugging/Testing Section - Carrier Module
// Uncomment this block to test the carrier module in isolation
// =======================================================

/*
// Test a Planetary Carrier (uncomment to see only the carrier)
// We'll use the parameters from _helper.scad
color("darkgray") create_planetary_carrier(
    num_planets = 3, // Assuming 3 planet gears for now
    carrier_height = gear_height + axial_clearance_per_stage, // Match height used in main assembly
    boss_extension_height = 2, // EXAMPLE: Bosses extend 2mm above the carrier
    planet_pin_d = planet_pin_diameter,
    sun_gear_bore_d = motor_shaft_diameter,
    output_shaft_d = 8 // Example output shaft diameter for carrier output shaft
);
*/