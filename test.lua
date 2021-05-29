-- 
--  test.lua
--  lua-astar
--  
--  Created by Jay Roberts on 2011-01-12.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 
--  This is a simple test script which demonstrates the AStar class in use.
--


local AStar = require 'BaseComponent/AStar/astar'
require 'BaseComponent/AStar/tiledmaphandler'
require 'BaseComponent/AStar/profiler'


local handler = TiledMapHandler()
local astar = AStar(handler)

local GameObject = CS.UnityEngine.GameObject
local Resources = CS.UnityEngine.Resources
local grid = Resources.Load("UIPrefabs/Grid", typeof(GameObject))
local grid_panel = GameObject.Find("GridPanel")

local function InitGird(go, i, j)
  go.transform:SetParent(grid_panel.transform)
  go.transform.localScale = {x = 1, y = 1, z = 1}
  go.transform.localPosition = {x = 0, y = 0, z = 0}

  local rect = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
  rect.anchoredPosition = {x = i*30, y = -j*30, z = 0}
end

local grids = {}

for i = 1, table.length(handler.tiles) do
  grids[i] = grids[i] or {}
  for j = 1, table.length(handler.tiles[i]) do
    local go = GameObject.Instantiate(grid)
    grids[i][j] = go
    InitGird(go, i, j)
    local img = go:GetComponent(typeof(CS.UnityEngine.UI.Image))
    if handler.tiles[i][j] == 0 then
      img.color = CS.UnityEngine.Color.white
    else
      img.color = CS.UnityEngine.Color.black
    end
  end
end

print 'Beginning...'

for i = 1, 10 do

   local start = {
     x = math.random(1, 23),
     y = math.random(1, 23)
   }

   local goal = {
      x = math.random(1, 23),
      y = math.random(1, 23)
   }
   
   -- print(string.format('Testing: (%i, %i) (%i, %i)', start.x, start.y, goal.x, goal.y))
   
   local path = astar:findPath(start, goal)
   if path then
     for k, v in pairs(path.nodes) do
      for k1, node in pairs(v) do
        print(k,v)
      end
      grids[v.location.y][v.location.x].transform:GetComponent(typeof(CS.UnityEngine.UI.Image)).color =  CS.UnityEngine.Color.yellow
     end
     break
   end
end

print 'Done'


