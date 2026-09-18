-- Habileté innée : saut simple (poule des bois).

local Jump = {}

Jump.id = "jump"
Jump.description = "Saut simple au sol."

function Jump.apply(player, input)
  if input.jumpPressed and player.onGround then
    player.vy = -player.jumpForce
    player.onGround = false
    return true
  end
  return false
end

return Jump
