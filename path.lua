
local Path = class('Path')
function Path:initialize(nodes, totalCost)
  self.nodes = nodes
  self.totalCost = totalCost
end

function Path:getNodes()
  return self.nodes
end

function Path:getTotalMoveCost()
  return self.totalCost
end

return Path
