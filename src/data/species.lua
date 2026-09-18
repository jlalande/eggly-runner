-- Catalogue des espèces : chaque œuf jouable dérive d'une espèce
-- avec habileté innée (pas un simple skin).

local Species = {}

Species.list = {
  poule_des_bois = {
    id = "poule_des_bois",
    displayName = "Poule des bois",
    animal = "poule",
    stats = {
      jumpForce = 420,
      gravityScale = 1.0,
      runSpeedBias = 0,
    },
    abilityId = "jump",
    spriteKey = "egg",
    palette = {
      shell = { 245 / 255, 230 / 255, 200 / 255 },
      crest = { 200 / 255, 60 / 255, 50 / 255 },
    },
    selectable = true,
  },

  -- Stub : format verrouillé, non sélectionnable dans le MVP
  grenouille = {
    id = "grenouille",
    displayName = "Grenouille",
    animal = "grenouille",
    stats = {
      jumpForce = 380,
      gravityScale = 0.95,
      runSpeedBias = 0,
    },
    abilityId = "double_jump", -- stub
    spriteKey = "egg_frog", -- asset futur
    palette = {
      shell = { 140 / 255, 200 / 255, 120 / 255 },
      crest = { 60 / 255, 140 / 255, 80 / 255 },
    },
    selectable = false,
  },

  -- Stub : format verrouillé, non sélectionnable dans le MVP
  kangourou = {
    id = "kangourou",
    displayName = "Kangourou",
    animal = "kangourou",
    stats = {
      jumpForce = 520,
      gravityScale = 1.05,
      runSpeedBias = 0,
    },
    abilityId = "high_jump", -- stub
    spriteKey = "egg_roo", -- asset futur
    palette = {
      shell = { 220 / 255, 180 / 255, 140 / 255 },
      crest = { 160 / 255, 100 / 255, 70 / 255 },
    },
    selectable = false,
  },
}

Species.starterId = "poule_des_bois"

function Species.get(id)
  return Species.list[id]
end

function Species.starter()
  return Species.list[Species.starterId]
end

return Species
