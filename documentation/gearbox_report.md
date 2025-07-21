# Planetary Gearbox Design Report

## 1. Introduction
* Brief overview of the project and the problem statement (design a compact planetary gearbox).
* State the key constraints and target specifications (75mm D, 25mm H, 1:216 reduction, 0.1 Nm input torque target).

## 2. Design Choices & Justification
* **Gearbox Type Selection:** Explain why a planetary gearbox was chosen (compactness, coaxial, load sharing). (Refer to `research_notes.md`)
* **Material Selection:** Justify the initial choice of PLA (printability, cost) while acknowledging its limitations. (Refer to `research_notes.md` and `material_properties_pla.md`)
* **Number of Stages & Ratio Distribution:** Explain why 3 stages were used and the 6:1 ratio per stage. (Refer to `research_notes.md`)
* **Gear Tooth Profile:** Briefly explain the involute profile choice. (Refer to `research_notes.md`)

## 3. Final Design Parameters
* Introduce the optimized parameters derived from your `calculations.xlsx`.
* **Table: Gearbox Design Parameters**
    | Parameter           | Value      | Unit |
    | :------------------ | :--------- | :--- |
    | Overall Reduction   | 1:216      |      |
    | Number of Stages    | 3          |      |
    | Module (m)          | 1.1        | mm   |
    | Sun Gear Teeth (Ns) | 12         |      |
    | Planet Gear Teeth (Np)| 24        |      |
    | Ring Gear Teeth (Nr) | 60         |      |
    | Gear Height (Face Width) | 5      | mm   |
    | Carrier Plate Height| 2.5        | mm   |
    | Top/Bottom Plate Thickness | 2   | mm   |
    | Total Vertical Clearance | 1       | mm   |

## 4. Dimensional Analysis
* Present the calculated dimensions based on your design parameters.
* Discuss how these meet the constraints.
* **Table: Overall Dimensions**
    | Dimension             | Calculated Value | Constraint | Status |
    | :-------------------- | :--------------- | :--------- | :----- |
    | Max Outer Diameter    | [Value from Excel] | 75 mm      | Met    |
    | Total Height          | [Value from Excel] | 25 mm      | Met    |
    | Motor Shaft Min Pitch Dia | 13.2 mm       | 5 mm       | Met    |

## 5. Strength Analysis
* **Methodology Overview:** Briefly summarize your approach (simplified analytical, static analysis, spreadsheet). Refer to `strength_analysis_plan.md` for full details.
* **Material Properties Used (for Calculations):**
    * Present the PLA properties you used in your calculations.
    * **Table: PLA Material Properties (for Calculations)**
        | Property                 | Value | Unit |
        | :----------------------- | :---- | :--- |
        | Tensile Strength (UTS, XY)| [B4]  | MPa  |
        | Yield Strength (XY plane)| [B5]  | MPa  |
        | Yield Strength (Z-axis)  | [B6]  | MPa  |
        | Shear Strength           | [B7]  | MPa  |
* **Input Torque & Factor of Safety:**
    * Clearly state the input torque used in your calculations for PLA.
    * **Crucially, explain that this input torque was manually adjusted to achieve a Factor of Safety of 1.56, as the target 0.1 Nm was not feasible with PLA.**
* **Table: Strength Analysis Results (for the achieved FoS)**
    * Extract key results from your `Strength & Torque` sheet. Focus on the critical components.
    | Component      | Stress Type | Calculated Stress | Material Yield | Factor of Safety | Status |
    | :------------- | :---------- | :---------------- | :------------- | :--------------- | :----- |
    | Sun Gear Tooth | Bending     | [Value]           | [B6]           | 1.56             | OKAY   |
    | Planet Pin     | Shear       | [Value]           | [B7]           | [Value]          | OKAY   |
    | Output Shaft   | Shear       | [Value]           | [B7]           | [Value]          | OKAY   |
* **Limitations of Analysis:** Briefly reiterate the limitations (static only, no FEA, material variability).

## 6. Design Description (The "No CAD" Section)
* This is where you describe the visual aspects without images.
* **Overall Assembly:** "The gearbox consists of three stacked planetary stages enclosed within a cylindrical housing defined by a top and bottom plate."
* **Each Stage:** "Each stage comprises a central sun gear, three planet gears orbiting the sun, and an outer ring gear. The planet gears are mounted on pins secured to a planet carrier."
* **Input & Output:** "The motor's 4mm shaft connects directly to the first stage's sun gear. The final stage's planet carrier serves as the gearbox's output shaft."
* **Component Details (as described above in Compensation Strategy 2):** Provide specific descriptions for the sun, planets, ring, carrier, pins, and plates, including how they interact and their function.
* **Assembly Concept:** Describe how the plates and carriers stack to form the full gearbox height, holding the gears in place.

## 7. Conclusions & Recommendations
* **Summary of Achievements:**
    * Successfully designed a 3-stage planetary gearbox meeting strict dimensional constraints (75mm D, 25mm H).
    * Achieved a 1:216 reduction ratio.
    * Determined the maximum input torque (0.00184 Nm) for PLA with an FoS of 1.56.
* **Limitations & Challenges:**
    * **Crucial Point:** Explicitly state that the initial target of 0.1 Nm input torque was **not achievable** with 3D printed PLA due to the high bending stresses on the small gear teeth, even after optimizing module and face width within the dimensional constraints.
* **Recommendations for Higher Torque Capacity:**
    * **Material Upgrade:** Recommend using stronger materials for gears, such as Carbon Fiber Reinforced Nylon (PA-CF), Nylon, or even metal (e.g., MIM gears if manufacturing allows). State typical yield strengths for these (e.g., Nylon 40-60 MPa Z-axis).
    * **Axle/Pin Material:** Recommend replacing PLA pins with **steel rods** for higher shear strength.
    * **Design Changes (if applicable for future versions):** If constraints were relaxed, suggest larger module, wider face width, or different gearbox types (e.g., worm gear for very high reduction in single stage, but different footprint).

## 8. References (from `research_notes.md` section)
