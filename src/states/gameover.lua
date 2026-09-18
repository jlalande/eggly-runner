local GameOver = {}

function GameOver:enter(shared)
  self.shared = shared or self.shared or {}
  self.blink = 0
end

function GameOver:update(dt)
  self.blink = self.blink + dt
end

function GameOver:draw()
  local w, h = love.graphics.getDimensions()
  love.graphics.setColor(0.15, 0.12, 0.1, 0.75)
  love.graphics.rectangle("fill", 0, 0, w, h)

  love.graphics.setColor(1, 0.85, 0.7)
  love.graphics.printf("Perdu !", 0, h * 0.28, w, "center")

  local score = self.shared.lastScore or 0
  local best = self.shared.best or 0
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(string.format("Score : %d", math.floor(score)), 0, h * 0.40, w, "center")
  love.graphics.printf(string.format("Meilleur : %d", math.floor(best)), 0, h * 0.48, w, "center")

  if math.floor(self.blink * 2) % 2 == 0 then
    love.graphics.setColor(0.9, 1, 0.85)
    love.graphics.printf("Entrée / Espace : rejouer", 0, h * 0.62, w, "center")
  end
  love.graphics.setColor(0.85, 0.85, 0.85, 0.9)
  love.graphics.printf("Échap : menu", 0, h * 0.72, w, "center")
end

function GameOver:keypressed(key)
  if key == "return" or key == "space" or key == "kpenter" then
    self.shared.switch("play")
  elseif key == "escape" then
    self.shared.switch("menu")
  end
end

function GameOver:mousepressed()
  self.shared.switch("play")
end

return GameOver
