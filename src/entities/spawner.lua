local Obstacle = require("src.entities.obstacle")

local Spawner = {}
Spawner.__index = Spawner

function Spawner.new()
  local self = setmetatable({}, Spawner)
  self.obstacles = {}
  self.timer = 0
  self.nextGap = 1.4
  return self
end

function Spawner:reset()
  self.obstacles = {}
  self.timer = 0
  self.nextGap = 1.4
end

local function gapForDistance(distance)
  -- Densité augmente avec la distance, plafonnée
  local t = math.min(distance / 2000, 1)
  local minGap = 0.75
  local maxGap = 1.6
  local base = maxGap - (maxGap - minGap) * t
  return base + love.math.random() * 0.35
end

function Spawner:update(dt, worldSpeed, worldDistance, screenWidth)
  self.timer = self.timer + dt
  if self.timer >= self.nextGap then
    self.timer = 0
    self.nextGap = gapForDistance(worldDistance)
    local x = screenWidth + 40
    -- Évite trop de chevauchement si le précédent est encore proche
    local last = self.obstacles[#self.obstacles]
    if last and last.x > screenWidth - 180 then
      x = last.x + 220 + love.math.random(0, 80)
    end
    table.insert(self.obstacles, Obstacle.new(x, Obstacle.randomType()))
  end

  for i = #self.obstacles, 1, -1 do
    local o = self.obstacles[i]
    o:update(dt, worldSpeed)
    if not o.alive then
      table.remove(self.obstacles, i)
    end
  end
end

function Spawner:draw()
  for _, o in ipairs(self.obstacles) do
    o:draw()
  end
end

return Spawner
