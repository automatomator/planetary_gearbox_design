# Research Notes: Compact Planetary Gearbox Design

## 1. Gearbox Type Selection

* **Decision:** Planetary Gearbox
* **Justification:**
    * **Compactness & High Reduction:** Planetary gear systems are exceptionally compact, offering high reduction ratios within a small volume compared to traditional parallel-shaft gearboxes. This was critical to meet the strict dimensional constraints.
    * **Coaxial Input/Output:** The design naturally provides coaxial input and output shafts, simplifying integration with motors and driven components.
    * **Load Sharing:** Multiple planet gears distribute the load, potentially increasing torque capacity and improving durability compared to single-mesh systems (though simplified analysis might assume single tooth load for conservatism).
    * **Efficiency:** Generally high efficiency due to fewer meshes compared to equivalent parallel-shaft systems for the same reduction.

## 2. Material Selection

* **Decision:** PLA (Polylactic Acid) for 3D Printed Gears and Housing components.
* **Justification:**
    * **Ease of 3D Printing:** PLA is widely accessible, easy to print, and offers good dimensional accuracy on FDM printers.
    * **Cost-Effectiveness:** It is an economical material, suitable for prototyping and educational projects.
    * **Initial Design Phase:** Chosen for its printability during the iterative design and dimensioning phase.
* **Initial Consideration of Limitations:** (Briefly mention here, elaborate in Strength Analysis Plan/Report)
    * Acknowledged lower strength compared to engineering plastics (e.g., Nylon) or metals.
    * Specific concern for anisotropic properties (weaker Z-axis strength in FDM printing) on gear teeth.

## 3. Dimensional Constraints & Target Specifications

* **Maximum Outer Diameter:** 75 mm (Strict constraint for form factor).
* **Maximum Total Height:** 25 mm (Strict constraint for form factor).
* **Overall Reduction Ratio Target:** 1:216 (Derived from project requirements).
* **Motor Output Shaft Minimum Pitch Diameter:** 5 mm (Ensures compatibility with motor).

## 4. Module Selection Rationale

* **Module (m):** Iteratively selected to balance tooth strength and overall gearbox size.
* **Initial Approach:** Started with a common small module (e.g., 0.75mm) suitable for compact designs.
* **Refinement:** Increased to `1.1 mm` (final value) to maximize tooth size and strength within the 75mm diameter constraint, utilizing available space. This was driven by the need to handle higher forces.

## 5. Number of Stages & Ratio Distribution

* **Decision:** 3-stage planetary gearbox.
* **Justification:** Required to achieve the high 1:216 overall reduction ratio without resorting to excessively high ratios in a single stage (which would necessitate very small sun gears and large ring gears, complicating design and potentially weakening components).
* **Ratio per Stage:** Maintained a balanced `6:1` ratio per stage (`6 x 6 x 6 = 216`). This ensures a relatively uniform distribution of load and gear sizes across the stages.
* **Optimized Tooth Counts (for 6:1 ratio):**
    * Sun Gear Teeth (Ns): 12
    * Planet Gear Teeth (Np): 24
    * Ring Gear Teeth (Nr): 60
    * (This combination was chosen over Ns=15, Nr=75 to allow for a larger module (1.1mm) while fitting within the diameter constraint.)

## 6. Gear Tooth Profile

* **Decision:** Standard Involute Gear Profile.
* **Justification:** Provides constant velocity ratio between meshing gears, good for power transmission, and standard for manufacturing (including 3D printing software).

### Further References and Resources

This section provides a curated list of textbooks and online resources for deeper learning in mechanical design, gearboxes (especially for robotics), and general engineering fundamentals, building upon the initial knowledge base.

#### Machine Design & Gearbox Fundamentals

* **Textbooks:**
    * **"Shigley's Mechanical Engineering Design"** by Richard G. Budynas and J. Keith Nisbett: A foundational text for comprehensive mechanical design principles, including stress analysis, material selection, and component design (gears, shafts, bearings).
    * **"Fundamentals of Machine Component Design"** by Robert C. Juvinall and Kurt M. Marshek: Offers a practical and complementary approach to mechanical component design.
    * **"Gear Handbook: The Design, Manufacture, and Application of Gears"** by Darle W. Dudley (or later editions): A highly detailed and authoritative reference specifically for in-depth gear design, manufacturing, and application.
    * **"Theory of Machines and Mechanisms"** by Joseph Edward Shigley and John Joseph Uicker Jr.: Focuses on the kinematics and dynamics of mechanical systems, crucial for understanding how gears move and interact.

* **Online Resources:**
    * **American Gear Manufacturers Association (AGMA):** [AGMA.org](https://www.agma.org/) - Sets industry standards for gear design and manufacturing. A primary reference for professional gear engineering.
    * **KHK Gears Technical Reference:** [KHK Gears Technical Reference](https://www.khkgears.us/new/gear_technical_reference/) - Provides accessible and practical technical information on gear basics and calculations.

#### Robotics & Mechatronics Design

* **Textbooks:**
    * **"Introduction to Robotics: Mechanics and Control"** by John J. Craig: A standard textbook that covers the mechanical and control aspects essential for robotic systems and their integrated components.
    * **"Mechatronics: Electronic Control Systems in Mechanical and Electrical Engineering"** by W. Bolton: Bridges mechanical engineering with electronics and control systems, defining the core of mechatronics and robotics.

* **Online Resources:**
    * **Robot Operating System (ROS) Documentation:** [ROS.org](http://www.ros.org/) - Essential for understanding the software architecture and control paradigms prevalent in modern robotics.
    * **Adafruit Learn / SparkFun Learn:** [learn.adafruit.com](https://learn.adafruit.com/) / [learn.sparkfun.com](https://learn.sparkfun.com/) - Excellent for hands-on, practical tutorials on hobbyist robotics, electronics, motor integration, and basic mechanical aspects.

#### General Engineering Design & Fundamentals

* **Textbooks:**
    * **"Design of Machinery"** by Robert L. Norton: Focuses on the synthesis and analysis of mechanisms, emphasizing conceptual design and graphical methods for creating new mechanical systems.
    * **"Engineering Design: A Project-Based Introduction"** by Clive L. Dym and Patrick Little: Covers the comprehensive engineering design process, from problem definition through detailed design.
    * **"Materials Science and Engineering: An Introduction"** by William D. Callister Jr. and David G. Rethwisch: A fundamental text for understanding material properties, behavior under stress, and processing methods, crucial for informed material selection.

* **Online Resources:**
    * **OpenSCAD:** [OpenSCAD.org](https://www.openscad.org/) - A software for creating solid 3D CAD objects using a textual description language. Ideal for parametric designs, especially useful for generating precise gear geometries for 3D printing.

    * **Fundamentals of Solid and Surface Modeling:**
        * **Textbooks:**
            * **"CAD/CAM: Computer-Aided Design and Manufacturing"** by Ibrahim Zeid and R. S. Sivasubramanian: Covers the theoretical foundations of CAD/CAM systems, including various geometric modeling techniques (wireframe, surface, solid modeling) and their computational aspects.
            * **"Solid Modeling and Applications: Rapid Prototyping, CAD and CAM Technologies"** by G. R. Lindbeck: Specifically focuses on solid modeling principles, its mathematical basis, and its practical applications in areas like rapid prototyping and manufacturing.
        * **Online Tutorials & Platforms:**
            * **Autodesk Fusion 360 Learning Tutorials:** [autodesk.com/products/fusion-360/learn-support/tutorials](https://www.autodesk.com/products/fusion-360/learn-support/tutorials) - Comprehensive official tutorials covering solid, surface, and mesh modeling within a popular integrated CAD/CAM software.
            * **SolidWorks Tutorials:** [solidworks.com/support/getting-started/](https://www.solidworks.com/support/getting-started/) - Industry-standard software with extensive tutorials for parametric solid modeling.
            * **Onshape Learning Center:** [onshape.com/en/learning](https://www.onshape.com/en/learning) - Offers tutorials for cloud-native parametric solid modeling and collaborative design.
            * **Blender Guru (for Blender):** [blenderguru.com](https://www.blender.com/) - While animation-focused, provides excellent tutorials for mastering robust modeling tools, particularly for organic and complex surface modeling.
            * **Online Learning Platforms (Coursera, edX, Udemy, LinkedIn Learning):** Search for structured courses like "Introduction to CAD," "Solid Modeling for Engineers," or "Advanced Surfacing Techniques" to gain in-depth knowledge from various instructors.

    * **General Engineering & CAD Communities:**
        * **Engineer's Edge:** [EngineersEdge.com](https://www.engineersedge.com/) - A broad resource for engineering formulas, design data, and tutorials across various disciplines.
        * **GrabCAD Community Library:** [GrabCAD.com/library](https://www.grabcad.com/library) - A vast collection of free 3D CAD models, valuable for examining and learning from real-world engineering designs and implementations.
        * **CAD Software-Specific Forums (e.g., Fusion 360 forums, SolidWorks forums):** Excellent places to ask specific questions, troubleshoot problems, and learn from other users' experiences.