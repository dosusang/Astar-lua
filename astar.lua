require 'BaseComponent/AStar/middleclass'
local Path = require 'BaseComponent/AStar/path'

local AStar = class('AStar')
function AStar:initialize(maphandler) 
  self.mh = maphandler
end

function AStar:_getBestOpenNode()
  local bestNode = nil
  
  for lid, n in pairs(self.open) do
    if bestNode == nil then
      bestNode = n
    else
      if n.score <= bestNode.score then
        bestNode = n
      end
    end
  end
  
  return bestNode
end

function AStar:_tracePath(n)
  local nodes = {}
  local totalCost = n.mCost
  local p = n.parent
  
  table.insert(nodes, 1, n)
  
  while true do
    if p.parent == nil then
      break
    end
    table.insert(nodes, 1, p)
    p = p.parent
  end
  
  return Path(nodes, totalCost)
end

function AStar:_handleNode(node, goal)
  self.open[node.lid] = nil
  self.closed[node.lid] = node.lid
  
  assert(node.location ~= nil, 'About to pass a node with nil location to getAdjacentNodes')
  
  local nodes = self.mh:getAdjacentNodes(node, goal)

  for lid, n in pairs(nodes) do repeat
    if self.mh:locationsAreEqual(n.location, goal) then
      return n
    elseif self.closed[n.lid] ~= nil then -- Alread in close, skip this
      break
    elseif self.open[n.lid] ~= nil then -- Already in open, check if better score   
      local on = self.open[n.lid]
    
      if n.mCost < on.mCost then
        self.open[n.lid] = nil
        self.open[n.lid] = n
      end
    else -- New node, append to open list
      self.open[n.lid] =  n
    end
  until true end
  
  return nil
end

function AStar:findPath(fromlocation, tolocation)
  self.open = {}
  self.closed = {}
  
  local goal = tolocation
  local fnode = self.mh:getNode(fromlocation)

  local nextNode = nil

  if fnode ~= nil then
    self.open[fnode.lid] = fnode
    nextNode = fnode
  end  
  
  while nextNode ~= nil do
    local finish = self:_handleNode(nextNode, goal)
    
    if finish then
      return self:_tracePath(finish)
    end
    nextNode = self:_getBestOpenNode()
  end
  
  return nil
end

return AStar