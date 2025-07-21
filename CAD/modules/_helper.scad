// CAD/modules/_helper.scad

// =======================================================
// GLOBAL GEARBOX DESIGN PARAMETERS & KINEMATICS
// These parameters define the core geometry of your gearbox.
// Refer to your design report for optimized values.
// =======================================================

// Module (m): Defines the size of the gear teeth.
// From your report: Module (m) = 1.1 mm
gear_module_value = 1.1; // mm

// Pressure Angle: Standard angle for involute gears.
pressure_angle_deg = 20; // degrees (standard)

// Gear Height (Face Width): Thickness of the gear bodies.
// --- ADJUSTED FOR 25MM HEIGHT CONSTRAINT ---
gear_height = 4;      // mm (Reduced from 5mm)

// Gear Teeth Counts for a single stage planetary setup (Sun, Planet, Ring)
// Ensure these values satisfy the planetary condition: Ring_Teeth = Sun_Teeth + 2 * Planet_Teeth
// From your report: Sun=12, Planet=24, Ring=60
sun_teeth = 12;
planet_teeth = 24;
ring_teeth = sun_teeth + (2 * planet_teeth); // Calculated: 12 + 24 * 2 = 60

// Shaft Diameters
// Motor Shaft Min Pitch Dia from report: 5 mm (use this as a guide for the bore)
motor_shaft_diameter = 4;  // Example: Typical motor shaft diameter. Adjust to your specific motor.
planet_pin_diameter = 3;   // Example: Diameter of the pins for planet gears. Steel rods are recommended.

// Clearances for 3D Printing (Adjust as needed based on your printer's accuracy)
radial_clearance_shaft_bore = 0.2; // Extra radius added to shaft bores for fit (0.2mm on radius means 0.4mm on diameter)
// --- ADJUSTED FOR 25MM HEIGHT CONSTRAINT ---
axial_clearance_per_stage = 0.15; // Vertical clearance between gears/carriers in each stage (Reduced from 0.2mm - be cautious)
clearance_gear_mesh = 0.05; // Very small clearance, mostly for calculation robustness if needed.

// Global render quality setting (can be overridden per primitive or module)
// Lower values (e.g., 16-32) for faster previews (F5).
// Higher values (e.g., 64-128) for final renders (F6).
DEFAULT_FN = 64; // Can be overridden to lower values in main assembly for faster previews

// =======================================================
// Helper Functions (Do NOT modify these unless you know what you are doing)
// These functions calculate standard gear dimensions based on module and teeth count.
// =======================================================

// Function to calculate Pitch Diameter
function pitch_diameter(number_of_teeth, module_val) = number_of_teeth * module_val;

// Function to calculate Addendum (height of tooth above pitch circle)
function addendum(module_val) = module_val;

// Function to calculate Dedendum (depth of tooth below pitch circle)
// Standard dedendum is 1.25 * module for full-depth involute gears
function dedendum(module_val) = 1.25 * module_val;

// Function to calculate Outside Diameter (for external gears)
function outside_diameter(number_of_teeth, module_val) = pitch_diameter(number_of_teeth, module_val) + (2 * addendum(module_val));

// Function to calculate Root Diameter (for external gears)
function root_diameter(number_of_teeth, module_val) = pitch_diameter(number_of_teeth, module_val) - (2 * dedendum(module_val));

// =======================================================
// Derived Global Dimensions (for housing/assembly)
// =======================================================

// Define a common outer rim thickness for the ring gear's housing wall
ring_outer_rim_thickness = 4; // Example: 4mm thick solid wall for the ring gear

// Calculated outer diameter of the solid cylinder required to contain the internal ring gear teeth
// This is the theoretical "root diameter" of an internal gear (which is Pitch + 2*Dedendum for an external gear)
// plus some wall thickness for the outer rim of the ring gear.
// This variable is now globally accessible.
ring_gear_housing_bore_diameter = pitch_diameter(ring_teeth, gear_module_value) + (2 * dedendum(gear_module_value)) + (2 * ring_outer_rim_thickness);