-- Registre des modules d'habiletés innées.

local Abilities = {
  jump = require("src.abilities.jump"),
  double_jump = require("src.abilities.double_jump"),
  high_jump = require("src.abilities.high_jump"),
}

function Abilities.get(id)
  return Abilities[id]
end

return Abilities
