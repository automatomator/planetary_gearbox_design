// CAD/modules/gearbox_main.scad

// Main assembly file for the 3-stage planetary gearbox.

// Include helper parameters
include <modules/_helper.scad>;

// Include component modules
include <modules/gear_module.scad>;
include <modules/carrier_module.scad>;
include <modules/housing_parts.scad>; // New housing parts

// --- Global Render Quality (Optional Override) ---
// Uncomment and adjust for faster previews of the entire assembly:
// $fn = 32;

// --- Overall Gearbox Dimensions (from requirements) ---
overall_gearbox_diameter = 75; //
overall_gearbox_height = 25; //

// --- Calculated Stage Kinematics (from _helper.scad) ---
sun_pitch_radius = pitch_diameter(sun_teeth, gear_module_value) / 2;
planet_pitch_radius = pitch_diameter(planet_teeth, gear_module_value) / 2;
planet_orbit_radius = sun_pitch_radius + planet_pitch_radius; // Distance from sun center to planet center

// --- Individual Component Z-Heights ---
// Height of a single gear (from _helper.scad)
gear_component_height = gear_height;

// Height of the carrier plate itself (from carrier_module.scad, but derived from gear_height)
carrier_plate_height = gear_height + axial_clearance_per_stage; // Carrier plate slightly taller than gear for clearance

// Boss extension height on the carrier (how much bosses protrude above carrier plate)
carrier_boss_extension = 2; // Example: 2mm extension

// Total height of a carrier structure (plate + boss extension)
carrier_total_height = carrier_plate_height + carrier_boss_extension;

// Height of a single planetary stage unit (from bottom of sun to top of carrier/ring for next layer)
// This considers the sun gear, planets, carrier, and the vertical space needed before the next stage's sun gear.
// For a common stacked design:
// Stage_Height = Gear_Height (sun/planet) + Carrier_Plate_Height + Carrier_Boss_Extension + Axial_Clearance
// Let's refine this during assembly based on part stacking.
// A simpler way to manage vertical stacking: place components relative to each other.

// --- Output Shaft Diameter (for final gearbox output) ---
final_output_shaft_diameter = 8; // Example: Diameter for the carrier's output shaft

// --- Gearbox Assembly Module ---
module create_3_stage_gearbox() {
    // --- Overall Housing ---
    // Start with the bottom plate at Z=0
    create_housing_base();

    // The core cylindrical part of the housing containing the fixed ring gears
    // This will be a union of the ring gears at their respective heights,
    // possibly with a continuous outer wall.

    // Let's define the Z-offsets for each stage's *working plane* (where the bottom of the sun/carrier sits)
    // Stage 1: Sun gear at Z=0 (relative to housing base)
    stage1_z_offset = top_bottom_plate_thickness; // Sits on top of the base plate

    // Stage 2: Sits on top of Stage 1's carrier
    // Height of first stage components + a small clearance
    stage2_z_offset = stage1_z_offset + carrier_total_height + axial_clearance_per_stage; 

    // Stage 3: Sits on top of Stage 2's carrier
    stage3_z_offset = stage2_z_offset + carrier_total_height + axial_clearance_per_stage;

    // --- Ring Gears (Fixed to Housing) ---
    // The ring gears are integral to the housing.
    // Their Z-offset corresponds to the Z-offset of their respective stage.
    create_integrated_ring_gear(z_offset = stage1_z_offset);
    create_integrated_ring_gear(z_offset = stage2_z_offset);
    create_integrated_ring_gear(z_offset = stage3_z_offset);
    
    // --- Internal Planet Pin Supports (Optional but recommended for rigidity) ---
    // These supports extend from the base through the housing to hold planet pins in place.
    // They are bored through in a later step.
    // These need to align with the planet pin holes in the carrier.
    // For a 3-stage gearbox, these would pass through all stages.
    // Height needs to be (overall_gearbox_height - top_bottom_plate_thickness)
    // Let's model these as full height and then cut the carrier holes through them.
    total_pin_support_height = overall_gearbox_height - top_bottom_plate_thickness; // From top of base to bottom of lid

    // We'll place these supports within the housing, aligned with the planet's orbit.
    // These will be solid and then cut by the carrier's holes later.
    // The actual planet pins are separate rods that go into the cut holes.
    translate([0,0,top_bottom_plate_thickness]) { // Supports start on top of the base plate
        create_planet_pin_housing_supports(
            num_planets = 3, // Assuming 3 planets per stage
            planet_orbit_radius = planet_orbit_radius,
            support_height = total_pin_support_height
        );
    }

    // --- Stage 1 Components ---
    translate([0, 0, stage1_z_offset]) {
        // Sun Gear 1 (Input)
        color("red") create_gear(gear_type="sun", teeth_count=sun_teeth, gear_module_val=gear_module_value, height_val=gear_component_height, bore_d=motor_shaft_diameter);

        // Planet Carrier 1 (Output of Stage 1, Input for Stage 2 Sun Gear)
        color("purple") create_planetary_carrier(
            num_planets = 3,
            carrier_height = carrier_plate_height,
            boss_extension_height = carrier_boss_extension,
            planet_pin_d = planet_pin_diameter,
            sun_gear_bore_d = motor_shaft_diameter, // Clears motor shaft
            output_shaft_d = 8 // Placeholder, carrier connects to next sun
        );

        // Planet Gears 1 (on Carrier 1)
        // Positioned around the orbit radius
        for (i = [0 : 3 - 1]) { // Iterate for number of planets
            rotate([0, 0, i * (360 / 3)]) {
                translate([planet_orbit_radius, 0, 0]) {
                    color("green") create_gear(gear_type="planet", teeth_count=planet_teeth, gear_module_val=gear_module_value, height_val=gear_component_height, bore_d=planet_pin_diameter);
                }
            }
        }
    }

    // --- Stage 2 Components ---
    translate([0, 0, stage2_z_offset]) {
        // Sun Gear 2 (Integrated with Carrier 1)
        // This sun gear needs to have its bore diameter match the output_shaft_d of the previous carrier's central hub.
        color("red") create_gear(gear_type="sun", teeth_count=sun_teeth, gear_module_val=gear_module_value, height_val=gear_component_height, bore_d=8); // Bore matches prev carrier output_shaft_d

        // Planet Carrier 2 (Output of Stage 2, Input for Stage 3 Sun Gear)
        color("purple") create_planetary_carrier(
            num_planets = 3,
            carrier_height = carrier_plate_height,
            boss_extension_height = carrier_boss_extension,
            planet_pin_d = planet_pin_diameter,
            sun_gear_bore_d = 8, // Clears the previous carrier's hub
            output_shaft_d = final_output_shaft_diameter // Placeholder, carrier connects to next sun
        );

        // Planet Gears 2 (on Carrier 2)
        for (i = [0 : 3 - 1]) {
            rotate([0, 0, i * (360 / 3)]) {
                translate([planet_orbit_radius, 0, 0]) {
                    color("green") create_gear(gear_type="planet", teeth_count=planet_teeth, gear_module_val=gear_module_value, height_val=gear_component_height, bore_d=planet_pin_diameter);
                }
            }
        }
    }

    // --- Stage 3 Components ---
    translate([0, 0, stage3_z_offset]) {
        // Sun Gear 3 (Integrated with Carrier 2)
        color("red") create_gear(gear_type="sun", teeth_count=sun_teeth, gear_module_val=gear_module_value, height_val=gear_component_height, bore_d=final_output_shaft_diameter); // Bore matches prev carrier output_shaft_d

        // Planet Carrier 3 (Final Output Carrier)
        color("purple") create_planetary_carrier(
            num_planets = 3,
            carrier_height = carrier_plate_height,
            boss_extension_height = carrier_boss_extension,
            planet_pin_d = planet_pin_diameter,
            sun_gear_bore_d = final_output_shaft_diameter, // Clears the motor shaft that runs through
            output_shaft_d = final_output_shaft_diameter // This is the actual output shaft bore
        );

        // Planet Gears 3 (on Carrier 3)
        for (i = [0 : 3 - 1]) {
            rotate([0, 0, i * (360 / 3)]) {
                translate([planet_orbit_radius, 0, 0]) {
                    color("green") create_gear(gear_type="planet", teeth_count=planet_teeth, gear_module_val=gear_module_value, height_val=gear_component_height, bore_d=planet_pin_diameter);
                }
            }
        }
    }

    // --- Top Housing Lid ---
    // Position the lid at the very top of the assembly
    translate([0, 0, overall_gearbox_height - top_bottom_plate_thickness]) {
        create_housing_lid(output_shaft_diameter_final = final_output_shaft_diameter);
    }
    
    // --- Planet Pins ---
    // These are the physical pins that go through the carrier bosses and housing supports.
    // They are usually metal rods, so we model simple cylinders for them.
    // They go through the holes cut in the carrier bosses and housing supports.
    // Their height will be from the top of the base plate to the bottom of the lid.
    planet_pin_length = overall_gearbox_height - (2 * top_bottom_plate_thickness); // Length between plates
    
    translate([0, 0, top_bottom_plate_thickness]) { // Start pins from top of base plate
        for (i = [0 : 3 - 1]) { // For each set of 3 planet pins
            rotate([0, 0, i * (360 / 3)]) {
                translate([planet_orbit_radius, 0, 0]) {
                    color("silver") cylinder(h = planet_pin_length, d = planet_pin_diameter, $fn = DEFAULT_FN);
                }
            }
        }
    }

    // --- Motor Input Shaft ---
    // This shaft will drive the sun gear of Stage 1.
    // It extends from the bottom of the gearbox, through the base plate, and into the sun gear.
    motor_shaft_length = overall_gearbox_height; // Or longer if it protrudes from the bottom
    translate([0,0, -0.1]) { // Starts slightly below the base plate
        color("gold") cylinder(h = motor_shaft_length + 0.2, d = motor_shaft_diameter, center = true, $fn=DEFAULT_FN);
    }

    // --- Final Output Shaft ---
    // This shaft will be driven by the carrier of Stage 3.
    // It extends from the top of Stage 3 carrier, through the lid.
    output_shaft_length = overall_gearbox_height - stage3_z_offset; // From stage 3 carrier to top of lid (or longer)
    translate([0,0,stage3_z_offset + carrier_plate_height + carrier_boss_extension/2]) { // Starts from the top of the last carrier's boss
         color("darkgold") cylinder(h = output_shaft_length + 5, d = final_output_shaft_diameter, center = true, $fn=DEFAULT_FN);
    }

}

// --- Render the entire gearbox ---
create_3_stage_gearbox();