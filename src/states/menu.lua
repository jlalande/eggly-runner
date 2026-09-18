local Menu = {}

function Menu:enter(shared)
  self.shared = shared or self.shared or {}
  self.shared.best = self.shared.best or 0
  self.blink = 0
end

function Menu:update(dt)
  self.blink = self.blink + dt
end

function Menu:draw()
  local w, h = love.graphics.getDimensions()
  love.graphics.setColor(0.35, 0.55, 0.4)
  love.graphics.rectangle("fill", 0, 0, w, h)

  love.graphics.setColor(0.95, 0.9, 0.75)
  love.graphics.printf("Eggly Runner", 0, h * 0.28, w, "center")

  love.graphics.setColor(0.85, 0.95, 0.85)
  love.graphics.printf("Course forestière — œuf starter : Poule des bois", 0, h * 0.40, w, "center")

  if math.floor(self.blink * 2) % 2 == 0 then
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Appuie sur Entrée ou Espace pour courir", 0, h * 0.58, w, "center")
  end

  love.graphics.setColor(0.9, 0.9, 0.9, 0.8)
  love.graphics.printf("Saut : Espace / ↑ / clic", 0, h * 0.72, w, "center")
  if self.shared.best > 0 then
    love.graphics.printf(string.format("Meilleur score : %d", math.floor(self.shared.best)), 0, h * 0.80, w, "center")
  end
end

function Menu:keypressed(key)
  if key == "return" or key == "space" or key == "kpenter" then
    self.shared.switch("play")
  end
end

function Menu:mousepressed()
  self.shared.switch("play")
end

return Menu
