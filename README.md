# Joule-heating

My master thesis project about joule heating. The goal is to build a working simulation and
explore different FEM methods while considering nonlinearities and radiation.

# ToDo:
- [ ] theory
  - [ ] 3D -> 2D simplification
  - [ ] mixed vs normal FEM
- [ ] implementation
  - [x] environment & dependency installer
  - [ ] export geometry from PCC
  - [ ] read boundary geometry
  - [ ] mesh creation
  - [ ] mesh refinement
  - [ ] mesh plotting
  - [ ] matrix assemblers
  - [ ] solving methods
  - [ ] result plotting
  - [ ] benchmarks
- [ ] paper & presentation

# Virtual environment
Create: `python -m venv .py`
Activate: `source .py/bin/activate`
Deactivate: `deactivate`

# Dependencies
- `python 3.12.6`
others are fetched and installed into the virtual environment automatically
