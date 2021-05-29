-- 
--  tiledmaphandler.lua
--  lua-astar
--  
--  Created by Jay Roberts on 2011-01-12.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'BaseComponent/AStar/middleclass'
local Node = require 'BaseComponent/AStar/node'

TiledMapHandler = class('TiledMapHandler')

function TiledMapHandler:initialize()
  self.tiles = {
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,1,0,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  }
end

function TiledMapHandler:getNode(location)
  -- Here you make sure the requested node is valid (i.e. on the map, not blocked)
  if location.x > #self.tiles[1] or location.y > #self.tiles then
    -- print 'location is outside of map on right or bottom'
    return nil
  end

  if location.x < 1 or location.y < 1 then
    -- print 'location is outside of map on left or top'
    return nil
  end

  if self.tiles[location.y][location.x] == 1 then
    -- print(string.format('location is solid: (%i, %i)', location.x, location.y))
    
    return nil
  end

  return Node(location, 0, location.y * #self.tiles[1] + location.x)
end


function TiledMapHandler:getAdjacentNodes(curnode, dest)
  -- Given a node, return a table containing all adjacent nodes
  -- The code here works for a 2d tile-based game but could be modified
  -- for other types of node graphs
  local result = {}
  local cl = curnode.location
  local dl = dest
  
  for x = -1, 1 do
    for y = -1, 1 do
      if x ~= 0 or y ~= 0 then
        local n = self:_handleNode(cl.x + x, cl.y + y, curnode, dl.x, dl.y, x, y)
        if n then
          table.insert(result, n)
        end
      end
    end
  end

  return result
end

function TiledMapHandler:locationsAreEqual(a, b)
  return a.x == b.x and a.y == b.y
end

function TiledMapHandler:_handleNode(x, y, fromnode, destx, desty, addx, addy)
  -- Fetch a Node for the given location and set its parameters
  local loc = {
    x = x,
    y = y
  }
  
  local n = self:getNode(loc)
  
  if n ~= nil then
    local dx = math.max(x, destx) - math.min(x, destx)
    local dy = math.max(y, desty) - math.min(y, desty)
    local emCost = dx + dy
    
    if math.abs(addx) == 0 or math.abs(addy) == 0 then
      n.mCost = fromnode.mCost + 10
    else
      n.mCost = fromnode.mCost + 14
    end
    n.score = n.mCost + emCost
    n.parent = fromnode
    
    return n
  end
  
  return nil
end