local event = require("__flib__.event")
require('__toms-extra-walls__/utils')

local function generatorAdded(e)
    game.print("A sheild-generator was placed on tick " .. e.tick  );

    -- if global.prev_sheild then
    --   e.created_entity.set_beam_target(global.prev_sheild)
    -- end

    local pos = e.created_entity.position
    local surface = e.created_entity.surface
    local player = game.get_player(e.player_index);

    for x = 10,1,-1 
    do 

      if (x == 10 or x == 1) then
        for y = 9,2,-1 
        do 
          surface.create_entity{name = entity "shield-wall", position = {pos.x + x, pos.y + y}, force=player.force}
        end
      end

      surface.create_entity{name = entity "shield-wall", position = {pos.x + x, pos.y + 10}, force=player.force}
      surface.create_entity{name = entity "shield-wall", position = {pos.x + x, pos.y + 1}, force=player.force}
    end

    global.prev_sheild = e.created_entity;
end


script.on_init(function (e)
  local generators = game.find_entities_filtered({ name = entity "sheild-generator" })

  if #generators > 0 then
    game.print("found " .. #generators .. " sheild-generators")
  end

end)

local function sheildWallDamaged(e)
  game.print("A sheild-wall was damaged on tick " .. e.tick  );
end


event.register(
  {defines.events.on_built_entity, defines.events.on_robot_built_entity},
  generatorAdded,
  {
    { filter = "name", name = entity "sheild-generator" }
  }
)

event.register(
  {defines.events.on_entity_damaged},
  sheildWallDamaged,
  {
    { filter = "type", type = "wall" },
    { filter = "name", name = entity "shield-wall" }
  }
)