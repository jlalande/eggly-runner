-- Moteur de parallaxe multi-couches synchronisé à worldSpeed / worldDistance.

local Parallax = {}
Parallax.__index = Parallax

local function loadImage(path)
  local ok, img = pcall(love.graphics.newImage, path)
  if ok and img then
    img:setFilter("nearest", "nearest")
    return img
  end
  return nil
end

function Parallax.new(layers)
  local self = setmetatable({}, Parallax)
  self.layers = {}
  for _, def in ipairs(layers) do
    local layer = {
      id = def.id,
      scrollFactor = def.scrollFactor or 1,
      y = def.y or 0,
      tileWidth = def.tileWidth,
      height = def.height,
      image = def.image,
      drawFn = def.drawFn,
      repeatX = def.repeatX ~= false,
      scale = def.scale or 1,
      color = def.color,
    }
    if type(layer.image) == "string" then
      layer.image = loadImage(layer.image)
    end
    if layer.image and not layer.tileWidth then
      layer.tileWidth = layer.image:getWidth() * layer.scale
    end
    if layer.image and not layer.height then
      layer.height = layer.image:getHeight() * layer.scale
    end
    table.insert(self.layers, layer)
  end
  return self
end

function Parallax:draw(worldDistance, screenWidth)
  for _, layer in ipairs(self.layers) do
    if layer.color then
      love.graphics.setColor(layer.color)
    else
      love.graphics.setColor(1, 1, 1, 1)
    end

    if layer.drawFn then
      layer.drawFn(layer, worldDistance, screenWidth)
    elseif layer.image and layer.tileWidth then
      local tw = layer.tileWidth
      local offset = (worldDistance * layer.scrollFactor) % tw
      local startX = -offset
      local x = startX
      while x < screenWidth + tw do
        love.graphics.draw(layer.image, x, layer.y, 0, layer.scale, layer.scale)
        if not layer.repeatX then
          break
        end
        x = x + tw
      end
    end
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return Parallax
