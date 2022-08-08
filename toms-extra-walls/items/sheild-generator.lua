require('__toms-extra-walls__.utils')

-- To add new prototypes to the game I descripe each prototype in a table.
-- Then each of these tables is put together into one large table, and that large
-- table is handed to data:extend() which will put it into data.raw where
-- the game engine can find them.

data:extend({

  -- This is the item that is used to place the entity on the map.
  {
    type = 'item',
    name = item 'sheild-generator',

    -- In lua any function that is called with exactly one argument
    -- can be written without () brackets if the argument is a string or table.

    -- here we call sprite() which will return the full path:
    -- '__eradicators-hand-crank-generator__/sprite/hcg-item.png'

    icon      = sprite 'hcg-item.png', -- sprite('hcg-item.png')
    icon_size = 64,
    subgroup = "defensive-structure",
    order = "z[wall]-d[sheild-generator]",

    -- This is the name of the entity to be placed.
    -- For convenience the item, recipe and entity
    -- often have the same name, but this is not required.
    -- For demonstration purposes I will use explicit
    -- names here.
    place_result = entity 'sheild-generator',
    stack_size   = 50,
  },

})



-- The next step is slightly more complicated. According to the "lore" of this
-- mod the player only gets a single HCG. But because some people might want
-- more than one there is a "mod setting" that enables a technology and recipe.

-- So I have to read the setting and only create the technology and recipe prototypes
-- if the setting is enabled.

data:extend({
  {
    type = 'recipe',
    name = recipe 'sheild-generator',

    -- Recipes can have up to two different difficulties.
    -- Expensive is usually only used in "marathon" games.

    normal = {
      -- This only changes if the recipe is available from the start.
      -- Disabled recipes can later be unlocked by researching a technology.
      enabled = true,

      -- By the way: I put a lot of spaces everywhere so that the content of
      -- tables aligns better because I find it easier to read, but this is not nessecary.
      ingredients = {
        -- {'iron-gear-wheel'    ,10},
        -- {'electronic-circuit' , 2},
        -- {'copper-cable'       ,10},
        { 'iron-plate', 1 },
        -- {'copper-plate'       , 5},
      },

      result = item 'sheild-generator',

      -- Recipes always produce one item if nothing else is defined.
      -- result_count = 1,

      -- This is the TIME in seconds at crafting speed 1 to craft the item.
      -- So handcrafting a HCG will take 30 seconds, and an assembling-machine-1
      -- with only 0.5 crafting speed would need 60 seconds.
      -- Despite being called "energy" it does not affect the power consumed by
      -- assembline machines.
      energy_required = 1,
    }

  },


  -- This is the technology that will unlock the recipe.
  {
    name = tech 'sheild-generator',
    type = 'technology',
    enabled = true,

    icon = sprite 'hcg-technology.png',
    icon_size = 128,
    prerequisites = { "laser", "stone-wall" },

    effects = {
      { 
        type = 'unlock-recipe',
        recipe = recipe 'sheild-generator'
      },

    },

    unit = {
      count = 150,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 },
      },
      time = 30,
    },

    -- }, -- [1] put parameters directly into prototype

    order = "c-e-b2",
  },

})




-- Sometimes it's nessecary to prepare data outside of a prototype definition.
-- Because the HCG should be connectable to the circuit network the engine needs
-- to know where the cables should go.

-- Vanilla offers a premade function that makes it very easy to generate the
-- required data. But in the case of the HCG none of the premade connectors
-- has quite the right angle. So I take the template, make a copy of it and then
-- remove the yellow "base" from the connector so that only the cable attachments
-- remain. If I removed the base without copying the table first it would affect
-- EVERY entity in the game that uses this function afterwards.

-- Vanilla includes the "util" module that has some useful functions.

-- It doesn't look awesome, but it gets the job done.

-- local no_base_connector_template = util.table.deepcopy(universal_connector_template)
-- no_base_connector_template. connector_main   = nil --remove base
-- no_base_connector_template. connector_shadow = nil --remove base shadow

-- local connector = circuit_connector_definitions.create(no_base_connector_template,{{
--   -- The "variation" determines in which direction the connector is drawn. I look
--   -- at the file "factorio\data\base\graphics\entity\circuit-connector\hr-ccm-universal-04a-base-sequence.png"
--   -- and count from the left top corner starting with 0 to get the angle I want.
--   variation     = 25,
--   main_offset   = util.by_pixel(7.0, -4.0), -- Converts pixels to tile fractions
--   shadow_offset = util.by_pixel(7.0, -4.0), -- automatically for easier shifting.
--   show_shadow   = true
--   }})




-- When adding only a single prototype I like to put all the { brackets on one line.
data:extend { {

  -- This is the actual Hand Crank Generator Entity.
  -- Because there is no base prototype that behaves exactly as
  -- I want I chose a type that is close enough and add
  -- a control.lua script to control the exact behavior.

  -- At the beginning it's easiest to copy the whole prototype
  -- of a vanilla entity and remove / change the bits you don't need.

  type      = 'accumulator',
  name      = entity 'sheild-generator',
  flags     = { 'placeable-neutral', 'player-creation' },
  icon      = sprite 'hcg-item.png',
  icon_size = 64,

  -- In earlier versions the HCG could not be picked up once placed - because it was damaged
  -- during the crash landing. But some people complained that that was too inconvenient!
  minable = {
    mining_time = 0.5,
    result      = item 'sheild-generator'
  },

  max_health = 150,
  corpse = 'small-remnants', --what remains when the entity is destroyed.

  -- Tall entities should have different size "on the ground" than
  -- their visible size.
  collision_box= {{-1.2, -1.2}, {1.2, 1.2}},
  selection_box = {{-1.5, -1.5}, {1.5, 1.5}},


  energy_source = {
    type = 'electric',

    -- Making the HCG lower priority than normal generators
    -- ensures that it doesn't waste energy while steam power is available.
    usage_priority = 'tertiary',

    -- Because the HCG is technically an accumulator, so it's natural
    -- behavior is to take energy from the grid and store it. But as
    -- I want it to be only charged by hand I have to prevent that.
    input_flow_limit = '0kW',

    -- The mod settings take numbers, but prototypes must define energy
    -- related values as strings, so I have to convert them.
    buffer_capacity = tostring(
      math.ceil(
        config 'run-time-in-seconds' * config 'power-output-in-watts'
      )
    ) .. 'J',

    output_flow_limit = tostring(
      config 'power-output-in-watts'
    ) .. 'W',

    -- Sometimes it's useful to hide the "missing cable" and "no power" icons.
    -- But I don't need that for HCG.
    -- render_no_network_icon = false,
    -- render_no_power_icon   = false,
  },

  --Vanilla factorio comes with some predefined sound groups for
  --when you drive into a building at full speed yet again.

  --They are stored in a seperate file so I need to load that file.
  --Normally require() should only be used at the beginning of a
  --source code file so the result can be used multiple times
  --throughout the file. I am making an exception here for the sake
  --of keeping the tutorial in a readable non-confusing order.
  --You shouldn't do this, but it gives me a chance to show you
  --that require() behaves like any other function and returns
  --the result of reading a file. In this case a table of tables,
  --of which I am only interested in a single sub-table.
  vehicle_impact_sound = require("__base__/prototypes/entity/sounds")['generic_impact'],

  --The sound that is played while the HCG is discharging (=producing energy).
  --The sound for charging is played via control.lua script, but if HCG was a
  --normal accumulator this sound would be used for charging too.
  working_sound = {
    sound = {
      filename = sound 'tank-engine-slow.ogg', --base game sound slowed by 50%
      volume = 0.65
    },
  },

  -- I want the HCG to look fancy! For that I need an animation.
  -- In factorio and many other sprite-based 2D games animations are
  -- stored as a single large picture - a so called "sprite sheet".
  -- This sprite sheet contains all frames of the animation, so i
  -- have to tell the engine how large each frame is, and how many
  -- frames there are in total.
  discharge_animation = {
    filename = sprite 'hcg-animation.png',
    width    = 128,
    height   = 128,

    --The sprite sheet has 3 rows with 8 pictures each. So there
    --are 24 frames in total. But the code is much nicer to read
    --if I just write this as a formula.
    line_length = 8,
    frame_count = 3 * 8,

    -- Originally vanilla graphics had 32 pixels per 1 tile. But later
    -- High resolution graphics with 64 pixels per tile were added.
    -- The HCG is rendered in high resolution, so it has to be shown at half
    -- the size to fit with the original 32 pixel standard.
    scale = 0.5,

    -- Shift is used when the center of a picture is
    -- not the visual center of the entity. I.e. because
    -- the picture also contains a shadow. Shift values
    -- are given in tiles.
    shift = { 0.5, -0.475 },

    -- By using a lower animation speed I can have a slow animation
    -- with fewer frames than i'd need at full speed.
    animation_speed = 0.25,
  },

  -- The rotating "dis/charge" animation should stop immedeatly if
  -- the player stops cranking/the hcg is empty. So I set this to one tick.
  charge_cooldown    = 1,
  discharge_cooldown = 1,

  -- Accumulator type entities need a single still image
  -- for when they're not dis-/charging. But I can just recycle
  -- the first frame of the animation!
  picture = {
    filename = sprite 'hcg-animation.png',
    priority = 'extra-high',
    width    = 128,
    height   = 128,
    shift    = { 0.5, -0.475 },
    scale    = 0.5,
  },
} }