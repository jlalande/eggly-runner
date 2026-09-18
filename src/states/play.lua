local Species = require("src.data.species")
local Player = require("src.entities.player")
local Spawner = require("src.entities.spawner")
local Parallax = require("src.world.parallax")
local Ground = require("src.world.ground")
local Hud = require("src.ui.hud")
local AABB = require("src.util.aabb")

local Play = {}

local BASE_SPEED = 220
local MAX_SPEED = 420

local function buildParallax()
  local groundY = Ground.getSurfaceY()
  return Parallax.new({
    {
      id = "sky",
      scrollFactor = 0.15,
      y = 0,
      image = "assets/sprites/sky.png",
      scale = 4, -- 128*4 = 512, tuilé horizontalement
    },
    {
      id = "farTrees",
      scrollFactor = 0.35,
      y = groundY - 200,
      image = "assets/sprites/far_trees.png",
      scale = 2.5,
    },
    {
      id = "midTrees",
      scrollFactor = 0.6,
      y = groundY - 260,
      image = "assets/sprites/mid_trees.png",
      scale = 2.2,
    },
    {
      id = "ground",
      scrollFactor = 1.0,
      y = groundY - 8,
      image = "assets/sprites/ground.png",
      scale = 2.5,
    },
  })
end

function Play:enter(shared)
  self.shared = shared or self.shared or {}
  self.shared.best = self.shared.best or 0

  self.species = Species.starter()
  self.player = Player.new(self.species)
  self.spawner = Spawner.new()
  self.parallax = buildParallax()

  self.worldDistance = 0
  self.worldSpeed = BASE_SPEED + (self.species.stats.runSpeedBias or 0)
  self.score = 0
  self.alive = true
  self.jumpPressed = false
end

function Play:speedForDistance(distance)
  local t = math.min(distance / 2500, 1)
  local bias = self.species.stats.runSpeedBias or 0
  return (BASE_SPEED + (MAX_SPEED - BASE_SPEED) * t) + bias
end

function Play:update(dt)
  if not self.alive then
    return
  end

  local input = { jumpPressed = self.jumpPressed }
  self.jumpPressed = false

  self.worldSpeed = self:speedForDistance(self.worldDistance)
  self.worldDistance = self.worldDistance + self.worldSpeed * dt
  self.score = self.worldDistance

  self.player:update(dt, input)
  self.spawner:update(dt, self.worldSpeed, self.worldDistance, love.graphics.getWidth())

  local px, py, pw, ph = self.player:getAABB()
  for _, o in ipairs(self.spawner.obstacles) do
    local ox, oy, ow, oh = o:getAABB()
    if AABB.overlaps(px, py, pw, ph, ox, oy, ow, oh) then
      self:gameOver()
      return
    end
  end
end

function Play:gameOver()
  self.alive = false
  self.worldSpeed = 0
  if self.score > self.shared.best then
    self.shared.best = self.score
  end
  self.shared.lastScore = self.score
  self.shared.switch("gameover")
end

function Play:draw()
  local w = love.graphics.getWidth()
  self.parallax:draw(self.worldDistance, w)
  self.spawner:draw()
  self.player:draw()
  Hud.draw(self.score, self.shared.best, self.species.displayName)
end

function Play:keypressed(key)
  if key == "space" or key == "up" or key == "w" then
    self.jumpPressed = true
  elseif key == "escape" then
    self.shared.switch("menu")
  end
end

function Play:mousepressed()
  self.jumpPressed = true
end

return Play
