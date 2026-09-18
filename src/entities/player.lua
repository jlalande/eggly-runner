local Abilities = require("src.abilities.init")
local Ground = require("src.world.ground")

local Player = {}
Player.__index = Player

local BASE_GRAVITY = 980
local SCALE = 2.5

local function loadFrames(prefix, count)
  local frames = {}
  for i = 0, count - 1 do
    local path = string.format("assets/sprites/%s_%d.png", prefix, i)
    local ok, img = pcall(love.graphics.newImage, path)
    if ok and img then
      img:setFilter("nearest", "nearest")
      table.insert(frames, img)
    end
  end
  return frames
end

function Player.new(species)
  local self = setmetatable({}, Player)
  self.species = species
  self.displayName = species.displayName
  self.ability = Abilities.get(species.abilityId)
  self.jumpForce = species.stats.jumpForce
  self.gravityScale = species.stats.gravityScale or 1
  self.runSpeedBias = species.stats.runSpeedBias or 0

  self.x = 140
  self.w = 32 * SCALE
  self.h = 40 * SCALE
  self.y = Ground.getSurfaceY() - self.h
  self.vy = 0
  self.onGround = true

  self.runFrames = loadFrames("egg_run", 4)
  self.jumpFrames = loadFrames("egg_jump", 2)
  self.animTimer = 0
  self.animFrame = 1
  self.scale = SCALE

  return self
end

function Player:getAABB()
  -- Hitbox un peu plus serrée que le sprite
  local padX = 6
  local padY = 4
  return self.x + padX, self.y + padY, self.w - padX * 2, self.h - padY
end

function Player:update(dt, input)
  if self.ability then
    self.ability.apply(self, input)
  end

  self.vy = self.vy + BASE_GRAVITY * self.gravityScale * dt
  self.y = self.y + self.vy * dt

  local groundY = Ground.getSurfaceY() - self.h
  if self.y >= groundY then
    self.y = groundY
    self.vy = 0
    self.onGround = true
  else
    self.onGround = false
  end

  self.animTimer = self.animTimer + dt
  if self.onGround then
    if self.animTimer >= 0.1 then
      self.animTimer = 0
      self.animFrame = (self.animFrame % #self.runFrames) + 1
    end
  else
    self.animFrame = (self.vy < 0) and 1 or 2
  end
end

function Player:draw()
  local frames = self.onGround and self.runFrames or self.jumpFrames
  local frame = frames[math.min(self.animFrame, #frames)] or frames[1]
  if frame then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(frame, self.x, self.y, 0, self.scale, self.scale)
  else
    love.graphics.setColor(self.species.palette.shell)
    love.graphics.ellipse("fill", self.x + self.w / 2, self.y + self.h / 2, self.w / 2, self.h / 2)
  end
end

return Player
