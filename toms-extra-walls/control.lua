require('__toms-extra-walls__/utils')
local event = require("__flib__.event")
local direction = require("__flib__.direction")

event.on_init(function ()
    global.shield_generators = global.shield_generators or {}
    global.sheild_pairs = global.sheild_pairs or {}
end)

event.on_configuration_changed(function () 
    global.shield_generators = global.shield_generators or {}
    global.sheild_pairs = global.sheild_pairs or {}
end)

function attachNorth(unit_number, pair_unit_number)
    game.print("Attaching generator to the North")
    global.sheild_pairs[unit_number] = global.sheild_pairs[unit_number] or {}
    global.sheild_pairs[unit_number][direction.north] = pair_unit_number
    global.sheild_pairs[pair_unit_number] = global.sheild_pairs[pair_unit_number] or {}
    global.sheild_pairs[pair_unit_number][direction.south] = unit_number
end

function attachSouth(unit_number, pair_unit_number)
    game.print("Attaching generator to the South")
    global.sheild_pairs[unit_number] = global.sheild_pairs[unit_number] or {}
    global.sheild_pairs[unit_number][direction.south] = pair_unit_number
    global.sheild_pairs[pair_unit_number] = global.sheild_pairs[pair_unit_number] or {}
    global.sheild_pairs[pair_unit_number][direction.north] = unit_number
end

function attachWest(unit_number, pair_unit_number)
    game.print("Attaching generator to the West")
    global.sheild_pairs[unit_number] = global.sheild_pairs[unit_number] or {}
    global.sheild_pairs[unit_number][direction.west] = pair_unit_number
    global.sheild_pairs[pair_unit_number] = global.sheild_pairs[pair_unit_number] or {}
    global.sheild_pairs[pair_unit_number][direction.east] = unit_number
end

function attachEast(unit_number, pair_unit_number)
    game.print("Attaching generator to the East")
    global.sheild_pairs[unit_number] = global.sheild_pairs[unit_number] or {}
    global.sheild_pairs[unit_number][direction.east] = pair_unit_number
    global.sheild_pairs[pair_unit_number] = global.sheild_pairs[pair_unit_number] or {}
    global.sheild_pairs[pair_unit_number][direction.west] = unit_number
end


function removeGenerator(unit_number)
    table.remove(global.shield_generators, unit_number)

    if (global.sheild_pairs[unit_number]) then
        local p = global.sheild_pairs[unit_number]

        if p[direction.north] then 
            game.print("found one north, removing");
            local pair_unit_number = p[direction.north]
            global.sheild_pairs[pair_unit_number][direction.south] = nil
        end

        if p[direction.south] then 
            game.print("found one south, removing");
            local pair_unit_number = p[direction.south]
            global.sheild_pairs[pair_unit_number][direction.north] = nil
        end

        if p[direction.east] then 
            game.print("found one east, removing");
            local pair_unit_number = p[direction.east]
            global.sheild_pairs[pair_unit_number][direction.west] = nil
        end

        if p[direction.west] then 
            game.print("found one west, removing");
            local pair_unit_number = p[direction.west]
            global.sheild_pairs[pair_unit_number][direction.east] = nil
        end

        global.sheild_pairs[unit_number] = nil
    end
end

event.register(
    {defines.events.on_built_entity, defines.events.on_robot_built_entity},
    function (e) 
        
        event.register_on_entity_destroyed(e.created_entity)
        local pos = e.created_entity.position
        game.print("Constructed Sheild Generator number #" .. e.created_entity.unit_number .. ' at ' .. string.format("[gps=%s, %s]", pos.x, pos.y) );

        
        for key, generator in pairs(global.shield_generators) do
            if not generator.valid then
                removeGenerator(key)
                goto continue
            end

            if generator.position.x == e.created_entity.position.x then 
                if ((generator.position.y < e.created_entity.position.y) and (e.created_entity.position.y - generator.position.y < 20)) then
                    attachNorth(e.created_entity.unit_number, generator.unit_number)
                end

                if ((generator.position.y > e.created_entity.position.y) and (generator.position.y - e.created_entity.position.y < 20)) then
                    attachSouth(e.created_entity.unit_number, generator.unit_number)
                end
            end

            if generator.position.y == e.created_entity.position.y then 
                if ((generator.position.x > e.created_entity.position.x) and (generator.position.x - e.created_entity.position.x < 20)) then
                    attachEast(e.created_entity.unit_number, generator.unit_number)
                end

                if ((generator.position.x < e.created_entity.position.x) and (e.created_entity.position.x - generator.position.x < 20)) then
                    attachWest(e.created_entity.unit_number, generator.unit_number)
                end
            end

            ::continue::
        end
        global.shield_generators[e.created_entity.unit_number] = e.created_entity
    end,
    {
        { filter = "name", name = entity "sheild-generator" } 
    }
)

event.register(
    defines.events.on_entity_destroyed,
    function (e)
        if (global.shield_generators[e.unit_number]) then
            game.print("Sheild Generator " .. e.unit_number .. " destroyed number on tick " .. e.tick);
            removeGenerator(e.unit_number)
        end
    end
)




-- local function generatorAdded(e)
--     game.print("A sheild-generator was placed on tick " .. e.tick  );

--     -- if global.prev_sheild then
--     --   e.created_entity.set_beam_target(global.prev_sheild)
--     -- end

--     local pos = e.created_entity.position
--     local surface = e.created_entity.surface
--     local player = game.get_player(e.player_index);

--     for x = 10,1,-1 
--     do 

--       if (x == 10 or x == 1) then
--         for y = 9,2,-1 
--         do 
--           surface.create_entity{name = entity "shield-wall", position = {pos.x + x, pos.y + y}, force=player.force}
--         end
--       end

--       surface.create_entity{name = entity "shield-wall", position = {pos.x + x, pos.y + 10}, force=player.force}
--       surface.create_entity{name = entity "shield-wall", position = {pos.x + x, pos.y + 1}, force=player.force}
--     end

--     global.prev_sheild = e.created_entity;
-- end


-- script.on_init(function (e)
--   local generators = game.find_entities_filtered({ name = entity "sheild-generator" })

--   if #generators > 0 then
--     game.print("found " .. #generators .. " sheild-generators")
--   end

-- end)

-- local function sheildWallDamaged(e)
--   game.print("A sheild-wall was damaged on tick " .. e.tick  );
-- end


-- event.register(
--   {defines.events.on_built_entity, defines.events.on_robot_built_entity},
--   generatorAdded,
--   {
--     { filter = "name", name = entity "sheild-generator" }
--   }
-- )

-- event.register(
--   {defines.events.on_entity_damaged},
--   sheildWallDamaged,
--   {
--     { filter = "type", type = "wall" },
--     { filter = "name", name = entity "shield-wall" }
--   }
-- )