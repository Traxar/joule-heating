# Boundary Data Format

This doc is meant to specify the data format, with which the boundary of the geometry is exported from PCC (ProgramControlCenter). This serves as a template to the reader implementation.


The Data is organized in a .csv structure (`,` next cell to the right, `\n` jump into first cell of the next row below).

Each decimal value is stored in utf8 in base 10 format with `.` noting the decimal.

The boundary is split into closed loops by empty rows.

Each loop consists of several rows.

Each row corresponds to one (directed) line/arc segment on the loop.

The domain is on the left of a segment.

Every row has the following format: `[x],[y],[curvature],[domain]`

- `[x]` and `[y]` denote the coordinates of the end point of the current segment in $m$.

- `[curvature]` defines the curvature of the segment (`=0` line, `>0` ccw, `<0` cw) in $m^{-1}$

  - arcs cannot have more than 180° (reason: uniqueness)

  - if it is impossible to connect 2 points with the given curvature, take the closest curvature were this is possible (reason: floating point errors)

- `[domain]` can take only 3 values (`0` gnd, `1` air, `2` voltage)

## Example

```
 0,2
  *---___ 1
  |       \
0 |        \
  |         |
  *---------*
 0,0  2   2,0
```
=>
```
0,0,0,1
2,0,0,2
0,2,0.5,1
```
