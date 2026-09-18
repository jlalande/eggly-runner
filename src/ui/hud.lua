local Hud = {}

function Hud.draw(score, best, speciesName)
  love.graphics.setColor(1, 1, 1, 0.95)
  love.graphics.print(string.format("Score : %d", math.floor(score)), 16, 12)
  love.graphics.print(string.format("Meilleur : %d", math.floor(best)), 16, 34)
  if speciesName then
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.print(speciesName, 16, 56)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return Hud
