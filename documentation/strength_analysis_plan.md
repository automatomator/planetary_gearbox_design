# Strength Analysis Plan: 3D Printed Planetary Gearbox

## 1. Objective of Analysis

The primary objective of this strength analysis is to evaluate the theoretical load-bearing capacity of the 3D-printed PLA planetary gearbox components under static loading conditions. The analysis aims to determine the maximum input torque that can be safely transmitted while maintaining an acceptable Factor of Safety (FoS) for critical components, specifically considering the anisotropic properties of Fused Deposition Modeling (FDM) printed parts.

## 2. Methodology

A simplified analytical approach using fundamental mechanical engineering principles and formulas was employed to calculate stresses and determine Factors of Safety. These calculations were performed within a spreadsheet (`calculations.xlsx`) to facilitate iterative design and analysis. This approach provides a first-order approximation of component performance.

## 3. Key Assumptions & Considerations

To simplify the analysis and provide a conservative estimate, the following assumptions and considerations were made:

* **Material Properties:**
    * **Material:** PLA (Polylactic Acid)
    * **Tensile Strength (UTS, XY plane):** 50 MPa
    * **Yield Strength (Tensile, XY plane):** 40 MPa
    * **Yield Strength (Tensile, Z-axis / Inter-layer Adhesion):** 20 MPa 
        This value is critically important for components primarily loaded in bending or tension perpendicular to the print layers (e.g., gear teeth).
    * **Shear Strength:** 24 MPa (calculated as 0.6 * Yield Strength XY).
    * **Assumption:** Material properties are assumed homogeneous and isotropic within the plane of the print layers (XY), but explicitly anisotropic for Z-axis loading where inter-layer adhesion is the limiting factor.

* **Loading Conditions:**
    * **Static Load Analysis:** All calculations are based on static loading conditions. Dynamic loads, shock loads, and fatigue are not explicitly calculated but are implicitly addressed by the chosen Factor of Safety.
    * **Uniform Load Distribution:** For planetary gears, it is conservatively assumed that the entire load is carried by a single planet gear mesh at any given instant. This accounts for potential manufacturing inaccuracies and uneven load sharing among multiple planets.
    * **Torque Transmission:** Torque is assumed to be transmitted purely through the pitch line of the gears for force calculations.

* **Component Geometry:**
    * **Ideal Geometry:** Components are assumed to have ideal geometric profiles as designed (e.g., perfect involute gear teeth). Manufacturing tolerances and surface finish are addressed by the Safety Factor.
    * **Nominal Dimensions:** Calculations use the nominal dimensions as defined in the `calculations.xlsx` file.

* **Factor of Safety (FoS) Target & Adjustment:**
    * **Initial Target:** A minimum Factor of Safety of 1.5 to 2.0 (or higher) is generally desired for plastic components to account for material variability, environmental factors, and simplified models.
    * **Achieved FoS & Input Torque Adjustment:** Due to the severe dimensional constraints and the chosen PLA material, the input torque for the calculations was manually adjusted until a consistent Factor of Safety of **1.54** was achieved for the most critically stressed component (the bending of the gear teeth). This specific FoS represents the maximum reliable input torque for the PLA design within the defined limits.

## 4. Critical Components & Failure Modes Analyzed

The analysis focused on the following critical components and their potential failure modes:

* **Gear Teeth:**
    * **Failure Mode:** Bending fatigue/fracture at the root of the tooth (Lewis/Buckingham method simplified for static analysis).
    * **Location:** Primarily the Sun Gear teeth in the last stage, as they experience the highest absolute forces.
* **Planet Pins/Axles:**
    * **Failure Mode:** Shear stress due to the load from the planet gear.
    * **Location:** Across the cross-section of the planet pins.
* **Main Output Shaft:**
    * **Failure Mode:** Shear stress due to the output torque.
    * **Location:** Along the cross-section of the output shaft (which is the carrier shaft in the final stage).

## 5. Formulas & Calculations Overview

The following fundamental formulas were utilized in the spreadsheet analysis:

* **Gear Tooth Bending Stress (Simplified Cantilever Beam Model):**
    * Force at Pitch Line ($F_t$): $F_t = \frac{2 \times T}{D_p}$ (where T is torque, $D_p$ is pitch diameter)
    * Section Modulus (Z): $Z = \frac{b \times t^2}{6}$ (where b is face width, t is tooth thickness at root)
    * Bending Moment (M): $M = F_t \times L$ (where L is effective moment arm from pitch line to root)
    * Bending Stress ($\sigma_b$): $\sigma_b = \frac{M}{Z}$
    * Factor of Safety (FoS): $FoS = \frac{\text{Material Yield Strength (Z-axis)}}{\sigma_b}$

* **Shaft/Pin Shear Stress:**
    * Shear Stress ($\tau$): $\tau = \frac{F}{A}$ (where F is the shear force, A is the cross-sectional area of the pin/shaft)
    * Factor of Safety (FoS): $FoS = \frac{\text{Material Shear Strength}}{\tau}$

* **Torque Calculations:**
    * Torque at each stage is calculated by multiplying the previous stage's torque by the reduction ratio of that stage.
    * Total Reduction Ratio ($R_{total}$): Product of individual stage ratios.
    * Output Torque ($T_{out}$): $T_{in} \times R_{total}$

## 6. Limitations of the Analysis

This analysis provides a foundational understanding of the gearbox's static strength but has inherent limitations:

* **Simplified Models:** Does not account for complex stress concentrations, dynamic loads, impact, or fatigue failure over time.
* **Material Variability:** Assumes consistent material properties, which can vary with 3D print parameters (temperature, infill, layer height) and filament quality.
* **Manufacturing Tolerances:** Does not directly incorporate the effects of manufacturing tolerances, backlash, or misalignment, which can affect load distribution.
* **No FEA:** Finite Element Analysis (FEA) would be required for a more detailed and accurate stress distribution and prediction of failure under complex loading.