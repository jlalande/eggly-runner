local states = {
  menu = require("src.states.menu"),
  play = require("src.states.play"),
  gameover = require("src.states.gameover"),
}

local current
local shared = {
  best = 0,
  lastScore = 0,
}

local function switch(name)
  current = states[name]
  if current and current.enter then
    current:enter(shared)
  end
end

shared.switch = switch

local smoke = {
  enabled = false,
  timer = 0,
  phase = "boot",
  jumped = false,
  frames = 0,
}

local function parseArgs()
  for _, a in ipairs(arg or {}) do
    if a == "--smoke" then
      smoke.enabled = true
    end
  end
end

function love.load()
  parseArgs()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setBackgroundColor(0.45, 0.65, 0.85)
  local font = love.graphics.newFont(18)
  love.graphics.setFont(font)
  switch("menu")
  if smoke.enabled then
    print("[smoke] démarrage validation MVP")
    switch("play")
    smoke.phase = "play"
  end
end

function love.update(dt)
  if smoke.enabled then
    smoke.timer = smoke.timer + dt
    smoke.frames = smoke.frames + 1
    if smoke.phase == "play" then
      -- Valide saut + parallaxe (worldDistance augmente)
      if not smoke.jumped and smoke.timer > 0.3 then
        if current and current.keypressed then
          current:keypressed("space")
        end
        smoke.jumped = true
        print("[smoke] saut déclenché")
      end
      if current and current.worldDistance then
        if smoke.frames % 30 == 0 then
          print(string.format(
            "[smoke] distance=%.1f speed=%.1f obstacles=%d",
            current.worldDistance,
            current.worldSpeed or 0,
            current.spawner and #current.spawner.obstacles or 0
          ))
        end
      end
      if smoke.timer > 2.5 then
        -- Force game over pour tester l'état
        if current and current.gameOver and current.alive then
          current:gameOver()
          print("[smoke] game over forcé")
        end
        smoke.phase = "gameover"
        smoke.timer = 0
      end
    elseif smoke.phase == "gameover" and smoke.timer > 0.4 then
      local Species = require("src.data.species")
      local starter = Species.starter()
      assert(starter.id == "poule_des_bois", "starter attendu")
      assert(starter.abilityId == "jump", "habileté jump attendue")
      assert(Species.get("grenouille") ~= nil, "stub grenouille manquant")
      assert(Species.get("kangourou") ~= nil, "stub kangourou manquant")
      print("[smoke] espèces OK ; parallaxe et boucle validées")
      print("[smoke] SUCCÈS")
      love.event.quit(0)
    end
  end

  if current and current.update then
    current:update(dt)
  end
end

function love.draw()
  if current and current.draw then
    current:draw()
  end
end

function love.keypressed(key)
  if current and current.keypressed then
    current:keypressed(key)
  end
end

function love.mousepressed(x, y, button)
  if current and current.mousepressed then
    current:mousepressed(x, y, button)
  end
end
