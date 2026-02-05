# Rick's ASHRAE 231P - CDL notes and Opinions 

Everything below is my notes on ASHRAE 231P "A Control Description Language" (or CDL for short), its intent and what it can become / should be.  These are my own musings and are <ins>not be interpreted as related to the CDL project or ASHRAE in any official context</ins>.  I am simply cataloging information in this doc and the others linked there in for my own purposes and and mental refinement which I hope to use to contribute to the project eventually. I will summerize starting from the original paper (below) which kicked off most of my oppinions and thoughts on this project and its benefits for the HVAC Automation industry as a whole.  Apologies for spelling mistakes as i generally developed this document on my own time, after working a full day, then being a father, then a husband, then what was left of that day came here.   

From [the original paper on CDL](https://simulationresearch.lbl.gov/wetter/download/2018-americanModelica-WetterGrahovacHu.pdf)
### Intro:
> "_The purpose of this paper is to describe a first implementation of 	<ins>a language with the intent to develop a standard for expressing building control sequences</ins>. This standard should support the mechanical designer in developing and testing control sequences within building energy simulations, and exporting these sequences to create unambiguous specifications for the control provider. It should support control providers in cost-estimation and in implementation of the control sequence on their control platform through machine-to-machine translation, and it should support the commissioning agent when verifying that the implemented control sequence meets the original specification._"

## Key points:
- develop a standard for expressing building control sequences
- support the mechanical designer in developing and testing control sequences within building energy simulations
- exporting these sequences to create unambiguous specifications for the control provider
- support control providers in cost-estimation
- implementation of the control sequence on their control platform through machine-to-machine translation
- support the commissioning agent when verifying that the implemented control sequence meets the original specification

![EnochRick's Breakdown of Purpose diagram](images/introDiagram.png)
This image from [the original paper on CDL](https://simulationresearch.lbl.gov/wetter/download/2018-americanModelica-WetterGrahovacHu.pdf) Wetter, M., Grahovac M., Hu J.
  Control Description Language,
  Lawrence Berkeley National Laboratory

<ins>Stakeholders:</ins>
- Mechanical Desinger - MEP PE workflows
- Constrols provider sales - System integrator bidding workflows
- Controls Provider programmer - System integrator programming / startup and turnover workflows
- Commissioning Agent - Validation and verification worflows

### CDL needs to satisfy these high level requirements:
- It must be independent of any control-vendor specific platform.
- It must be declarative to facilitate its translation to other languages.
- It must be possible to simulate controls expressed in the language within an annual building energy simulation.
- It must be deterministic, e.g., for given inputs and states, different implementations of sequences expressed must yield the same output and state updates (within the precision of ordinary differential equation solvers that may integrate PID controllers).
- It should be possible to translate the sequence to a variety of building control platforms.
- It must allow identification of cyclic graphs that would require iterative solutions and hence are not suited for implementation in building automation systems.

### thoughts on open Modelica
- install is full of extract operations for a lot of small files which makes the installation time SUPER long even on a modern high end PC - ask me how i know ;-)
- [User guide link](https://openmodelica.org/useresresources/userdocumentation/) on their site is broken link.
  - User guide in program works 

### General thoughts / Ideas to flush out:
===========================================
#### First issue - Who starts the process of using CDL commercially to solve our commerical problem?
----------------------------------------------------------------------------------------------------
- Look at where the overall intended workflow of CDL is and how it will fit practicall into commercial projects to acheive the goals of CDL.
  In their janurary 2022 paper[^Reference2], first paragraph of section 3 "Methodology" the intended CDL workflow starts with:
  >  Given regulations and efficiency targets, labeled as (1) in Fig. 2, a design engineer selects, configures, tests and evaluates the performance of a control sequence using building energy simulation (2), starting from a control sequence library that contains ASHRAE Guideline 36 sequences, as well as any user-added sequences (3), linked to a model of the mechanical system and the building (4). If the sequences meet closed-loop performance requirements, the designer exports a control specification, including the sequences and functional verification tests expressed in the Controls Description Language CDL (5)

They state a process that starts with the stakeholder of the "design engineer", who runs a simulation using CDL logic (maybe from a pre-built starting place).
They state after the simulations are satisfactory to the design engineer they export the CDL to be used in the actual programming and in commissioning.  
- **Rick's Hottake**: between the original 2018 paper[^Reference1] and 2022 the stakeholder that starts the intended commercial use is the design engineer. This is unchanged over this span of time, and therefore is the principal stakehodler upon which the CDL commerical use depends upon.  Therefore I stipualte that CDL must be low-to-no friction in its commercial use / application (this will be the basis of my drive for reviewing all of this work and collective feedback to these developers).  Without adpoption of CDL by the design community as Autocad has been adopted, CDL dies in its intended use.  **CDL must be as easy (and I would argue easier) to download/install/run and use productively than Autocad.** 

#### Second issue - Commercial friction - where time is money
----------------------------------------------------------------------------------------------------
 In their janurary 2022 paper[^Reference2], second paragraph of section 3 "Methodology" the intended CDL workflow then carries into a list of other software platforms the design engineer should / would be using :
 > For closed-loop performance assessment, step (2) in the figure, Modelica models of the HVAC systems and controls [34] can be linked to a Modelica envelope model [33] or to an EnergyPlus envelope model. This can currently be done through Spawn of EnergyPlus [38]. Library of control sequences, step (3), have been released with the Modelica Buildings Library 7.0.0 and more sequences are currently added to this library. To export control sequences in a vendor-neutral format, step (5), a translator from CDL to a json intermediate format has been developed [22]. The json intermediate format is to be used as input for cost estimation tools and for translators to vendor-specific product lines. This translator also outputs an English language description of the control sequence, including its block diagram representation.

**Listed Tools** This paragraph and assocaited tools imply the MEP design engineering firm is modeling MEP and Envelope in a whole building model
- Modelica (via Modelica envelope model)
  - Modelica Building Library 7.0.0
- EnergyPlus (same as above)
- Spawn of EnergyPlus
- CDL to JSON translator
  - JSON ingesting Cost Estmiation tools
  - JSON ingesting CDL to Vendor IDE translation tool (Developed by each vendor)
  - JSON to english description of CDL sequence & Block Diagram

- **Rick's Hottake**: the reason MEP designs and control implementations of their sequences fail is bigger than simple technology tools, its the forces of captialism acting on both segments of the construciton industy.  Without solving those problems and rethinking how buildings are contracted to be built those problems will not be engineered away.  Taking these forces into consideration, most MEP desing engineering firms sell time as their pricipal deliverable.  SO adding a list of tools to learn and complicated processes involved to model buildings correctly can be a FTE or more at a firm.  The ROI on that must be that the models match reality better than the competition and the first thing a FTE moddling professional will tell you is that these models dont genrally meet their real world coutnerparts and need to be calibrated.  Now CDL is asking to add another layer of complexity to this process which i would argue is competition-gated to the most expesive / elite MEP firms and thus not an industry standard practice.  While this is a nice to have, the reality is __unless__ the friction of using these tools under capitalism is reduced to the point where the cheapest MEP design engineer can model "good enough" in a "small enough" time frame, I put forth that this use case in industry will be less than 1% of all projects. 

####  Todo
----------
- Look at comparing the ease of use of CDL to that of the most commonly understood to be "open"[^5] controls platform: Tridium's Niagara
    - What subset of the entire Mechanical Engineering population understands Niagara in design?
    - What subset of the entire Controls Programming population understands Niagara in implementation?
    - What subset of the entire Commissioning population understand Niagara in validation?
- Compare Niagara to CDL for:
  - Training / onboarding of each of the three stakeholder groups
  - Deployment and use / reference material for help - troubleshooting
  - Ongoing Maintenance and upgrades
----------------------------------------

### Problems CDL will eventually solve
--------------------------------------
- Apples-to-Apples estimating for controls contractors
  - Level the playingfield for competition on ability rather than product in the HVAC Automation indusrty
- Testing and validation of controls sequences regardless of the controls platform
- Common industry programming lanugage which will allow open sourcing of the control code used in the HVAC automation industry
- New options on controls hardware / cross compatiblity with new automation hardware platforms that typically dont target the HVAC automation industry
- Deterministic States of control code execution - the same program will give the same output given the same inputs on any hardware
- The abiity to evolve from BACnet/Modbus and harden cybersecurity around control code via API access and machine to machine interoperability outside a traditionally Protocol-gated data model.  Machine to machine interaction in modern day IT systems are API based and the HVAC automation industry would benefit from this move too. CDL being expressed as JSON opens this door. 

### Relevant Links
- Open Building control Website [^Reference1]
- OpenBuildingControl: Digitizing the control delivery from building energy modeling to specification, implementation and formal verification, Wetter M., Ehrlich, P. Gautier, A. Grahovac, M. Haves P., Hu J., Prakash A., Robin D., Zhang K,[^Reference2]
- Buildings Controls OBC UsersGuide [^Reference3]
- Open Modelica [^Reference4]

[^5]: On "Open" above: Niagara is open in some ways, but really still not "open" by the standards of an "open source" community like.  Compare Niagara to Android, compare to Linux.
[^Reference1]: [Open Building control Website](https://obc.lbl.gov/)
[^Reference2]:[OpenBuildingControl: Digitizing the control delivery from building energy modeling to specification, implementation and formal verification, Wetter M., Ehrlich, P. Gautier, A. Grahovac, M. Haves P., Hu J., Prakash A., Robin D., Zhang K,.](https://www.sciencedirect.com/science/article/pii/S0360544221017497?via%3Dihub)
[^Reference3]:[Buildings Controls OBC UsersGuide](https://build.openmodelica.org/Documentation/Buildings.Controls.OBC.UsersGuide.html)
[^Reference4]:[Open Modelica](https://openmodelica.org/)
