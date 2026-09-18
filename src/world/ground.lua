-- Sol gameplay (collision Y) — aligné factor 1.0 avec la couche ground.

local Ground = {}

Ground.SURFACE_Y = 420
Ground.HEIGHT = 120

function Ground.draw()
  -- Dessiné via parallaxe ; helper pour hitbox debug éventuel.
end

function Ground.getSurfaceY()
  return Ground.SURFACE_Y
end

return Ground
