local Ground = require("src.world.ground")

local Obstacle = {}
Obstacle.__index = Obstacle

local TYPES = {
  rock = {
    sprite = "assets/sprites/obstacle_rock.png",
    w = 28,
    h = 24,
    scale = 2.2,
  },
  stump = {
    sprite = "assets/sprites/obstacle_stump.png",
    w = 24,
    h = 28,
    scale = 2.2,
  },
  bush = {
    sprite = "assets/sprites/obstacle_bush.png",
    w = 32,
    h = 22,
    scale = 2.2,
  },
}

local typeKeys = { "rock", "stump", "bush" }

local imageCache = {}

local function getImage(path)
  if not imageCache[path] then
    local ok, img = pcall(love.graphics.newImage, path)
    if ok and img then
      img:setFilter("nearest", "nearest")
      imageCache[path] = img
    end
  end
  return imageCache[path]
end

function Obstacle.randomType()
  return typeKeys[love.math.random(#typeKeys)]
end

function Obstacle.new(x, typeId)
  local def = TYPES[typeId] or TYPES.rock
  local self = setmetatable({}, Obstacle)
  self.typeId = typeId
  self.scale = def.scale
  self.w = def.w * def.scale
  self.h = def.h * def.scale
  self.x = x
  self.y = Ground.getSurfaceY() - self.h
  self.image = getImage(def.sprite)
  self.alive = true
  return self
end

function Obstacle:getAABB()
  local pad = 4
  return self.x + pad, self.y + pad, self.w - pad * 2, self.h - pad
end

function Obstacle:update(dt, worldSpeed)
  self.x = self.x - worldSpeed * dt
  if self.x + self.w < -40 then
    self.alive = false
  end
end

function Obstacle:draw()
  love.graphics.setColor(1, 1, 1, 1)
  if self.image then
    love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
  else
    love.graphics.setColor(0.4, 0.35, 0.3)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  end
end

return Obstacle
