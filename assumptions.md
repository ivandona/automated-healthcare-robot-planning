Assumptions:
- Boxes are limited, but can be reused
- Boxes can contain at most one supply
- Robots cannot fill a box while carrying it
- Robots cannot empty a box while carrying it
- Supplies and people are considered "delivered" when they are in the specified location. They are considered there only if they are dropped there, and not while being carried.
- Warehouse has infinite supplies
- Other locations can have max 1 supply of each type.
- Drones can fly, so they can enter from windows. However, they cannot go through corridors.

Implementation choices:
- Supplies modeled as generic (no instances). For this reason, need to track amount of supplies per type at a location. Robot do not track how much of something they have becuase
boxes can contain only one object.