function love.conf(t)
  t.identity = "eggly-runner"
  t.version = "11.5"
  t.console = false

  t.window.title = "Eggly Runner"
  t.window.width = 960
  t.window.height = 540
  t.window.resizable = false
  t.window.vsync = 1
  t.window.msaa = 0

  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
end
