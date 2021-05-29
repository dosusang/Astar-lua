
local Node = class('Node')
function Node:initialize(location, mCost, lid, parent)
  self.location = location -- Where is the node located
  self.mCost = mCost -- Total move cost to reach this node
  self.parent = parent -- Parent node
  self.score = 0 -- Calculated score for this node
  self.lid = lid -- set the location id - unique for each location in the map
end

function Node.__eq(a, b)
  return a.lid == b.lid
end

return Node