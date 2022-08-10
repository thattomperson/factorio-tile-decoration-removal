require("util")
require("__base__.prototypes.entity.pipecovers")
require("__base__.prototypes.entity.transport-belt-pictures")
require("__base__.prototypes.entity.transport-belt-pictures")
-- require("__base__.circuit-connector-sprites")
require("__base__.prototypes.entity.assemblerpipes")
require("__base__.prototypes.entity.laser-sounds")

require('__toms-extra-walls__/utils')

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")
-- local movement_triggers = require("__base__.prototypes.entity.movement-triggers")
-- local spidertron_animations = require("__base__.prototypes.entity.spidertron-animations")


data:extend { {
    type = "wall",
    name = entity "shield-wall",
    healing_per_tick = 5,
    icon = "__base__/graphics/icons/wall.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = { "not-repairable" },
    collision_box = { { -0.29, -0.29 }, { 0.29, 0.29 } },
    -- selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    damaged_trigger_effect = hit_effects.wall(),
    allow_copy_paste = false,
    max_health = 350,
    dying_explosion = "wall-explosion",
    vehicle_impact_sound = sounds.car_stone_impact,
    -- this kind of code can be used for having walls mirror the effect
    -- there can be multiple reaction items
    attack_reaction =
    {
        {
            -- how far the mirroring works
            range = 2,
            -- what kind of damage triggers the mirroring
            -- if not present then anything triggers the mirroring
            damage_type = "physical",
            -- caused damage will be multiplied by this and added to the subsequent damages
            reaction_modifier = 0.1,
            action =
            {
                type = "direct",
                action_delivery =
                {
                    type = "instant",
                    target_effects =
                    {
                        type = "damage",
                        -- always use at least 0.1 damage
                        damage = { amount = 0.1, type = "physical" }
                    }
                }
            },
        }
    },
    resistances =
    {
        {
            type = "physical",
            decrease = 3,
            percent = 20
        },
        {
            type = "impact",
            decrease = 45,
            percent = 60
        },
        {
            type = "explosion",
            decrease = 10,
            percent = 30
        },
        {
            type = "fire",
            percent = 100
        },
        {
            type = "acid",
            percent = 80
        },
        {
            type = "laser",
            percent = 70
        }
    },
    visual_merge_group = 1, -- different walls will visually connect to each other if their merge group is same (defaults to 0)
    pictures =
    {
        single =
        {
            layers =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-single.png",
                    priority = "extra-high",
                    width = 32,
                    height = 46,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -6),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-single.png",
                        priority = "extra-high",
                        width = 64,
                        height = 86,
                        variation_count = 2,
                        line_length = 2,
                        shift = util.by_pixel(0, -5),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-single-shadow.png",
                    priority = "extra-high",
                    width = 50,
                    height = 32,
                    repeat_count = 2,
                    shift = util.by_pixel(10, 16),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-single-shadow.png",
                        priority = "extra-high",
                        width = 98,
                        height = 60,
                        repeat_count = 2,
                        shift = util.by_pixel(10, 17),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
        straight_vertical =
        {
            layers =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-vertical.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 5,
                    line_length = 5,
                    shift = util.by_pixel(0, 8),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-vertical.png",
                        priority = "extra-high",
                        width = 64,
                        height = 134,
                        variation_count = 5,
                        line_length = 5,
                        shift = util.by_pixel(0, 8),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-vertical-shadow.png",
                    priority = "extra-high",
                    width = 50,
                    height = 58,
                    repeat_count = 5,
                    shift = util.by_pixel(10, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-vertical-shadow.png",
                        priority = "extra-high",
                        width = 98,
                        height = 110,
                        repeat_count = 5,
                        shift = util.by_pixel(10, 29),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
        straight_horizontal =
        {
            layers =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-horizontal.png",
                    priority = "extra-high",
                    width = 32,
                    height = 50,
                    variation_count = 6,
                    line_length = 6,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-horizontal.png",
                        priority = "extra-high",
                        width = 64,
                        height = 92,
                        variation_count = 6,
                        line_length = 6,
                        shift = util.by_pixel(0, -2),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-horizontal-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 36,
                    repeat_count = 6,
                    shift = util.by_pixel(14, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-horizontal-shadow.png",
                        priority = "extra-high",
                        width = 124,
                        height = 68,
                        repeat_count = 6,
                        shift = util.by_pixel(14, 15),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
        corner_right_down =
        {
            layers =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-corner-right.png",
                    priority = "extra-high",
                    width = 32,
                    height = 64,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-corner-right.png",
                        priority = "extra-high",
                        width = 64,
                        height = 128,
                        variation_count = 2,
                        line_length = 2,
                        shift = util.by_pixel(0, 7),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-corner-right-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 60,
                    repeat_count = 2,
                    shift = util.by_pixel(14, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-corner-right-shadow.png",
                        priority = "extra-high",
                        width = 124,
                        height = 120,
                        repeat_count = 2,
                        shift = util.by_pixel(17, 28),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
        corner_left_down =
        {
            layers =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-corner-left.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-corner-left.png",
                        priority = "extra-high",
                        width = 64,
                        height = 134,
                        variation_count = 2,
                        line_length = 2,
                        shift = util.by_pixel(0, 7),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-corner-left-shadow.png",
                    priority = "extra-high",
                    width = 54,
                    height = 60,
                    repeat_count = 2,
                    shift = util.by_pixel(8, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-corner-left-shadow.png",
                        priority = "extra-high",
                        width = 102,
                        height = 120,
                        repeat_count = 2,
                        shift = util.by_pixel(9, 28),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
        t_up =
        {
            layers =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-t.png",
                    priority = "extra-high",
                    width = 32,
                    height = 68,
                    variation_count = 4,
                    line_length = 4,
                    shift = util.by_pixel(0, 6),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-t.png",
                        priority = "extra-high",
                        width = 64,
                        height = 134,
                        variation_count = 4,
                        line_length = 4,
                        shift = util.by_pixel(0, 7),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-t-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 60,
                    repeat_count = 4,
                    shift = util.by_pixel(14, 28),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-t-shadow.png",
                        priority = "extra-high",
                        width = 124,
                        height = 120,
                        repeat_count = 4,
                        shift = util.by_pixel(14, 28),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
        ending_right =
        {
            layers =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-ending-right.png",
                    priority = "extra-high",
                    width = 32,
                    height = 48,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-ending-right.png",
                        priority = "extra-high",
                        width = 64,
                        height = 92,
                        variation_count = 2,
                        line_length = 2,
                        shift = util.by_pixel(0, -3),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-ending-right-shadow.png",
                    priority = "extra-high",
                    width = 62,
                    height = 36,
                    repeat_count = 2,
                    shift = util.by_pixel(14, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-ending-right-shadow.png",
                        priority = "extra-high",
                        width = 124,
                        height = 68,
                        repeat_count = 2,
                        shift = util.by_pixel(17, 15),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
        ending_left =
        {
            layers =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-ending-left.png",
                    priority = "extra-high",
                    width = 32,
                    height = 48,
                    variation_count = 2,
                    line_length = 2,
                    shift = util.by_pixel(0, -4),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-ending-left.png",
                        priority = "extra-high",
                        width = 64,
                        height = 92,
                        variation_count = 2,
                        line_length = 2,
                        shift = util.by_pixel(0, -3),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-ending-left-shadow.png",
                    priority = "extra-high",
                    width = 54,
                    height = 36,
                    repeat_count = 2,
                    shift = util.by_pixel(8, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-ending-left-shadow.png",
                        priority = "extra-high",
                        width = 102,
                        height = 68,
                        repeat_count = 2,
                        shift = util.by_pixel(9, 15),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
        filling =
        {
            filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-filling.png",
            priority = "extra-high",
            width = 24,
            height = 30,
            variation_count = 8,
            line_length = 8,
            shift = util.by_pixel(0, -2),
            hr_version =
            {
                filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-filling.png",
                priority = "extra-high",
                width = 48,
                height = 56,
                variation_count = 8,
                line_length = 8,
                shift = util.by_pixel(0, -1),
                scale = 0.5
            }
        },
        water_connection_patch =
        {
            sheets =
            {
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-patch.png",
                    priority = "extra-high",
                    width = 58,
                    height = 64,
                    shift = util.by_pixel(0, -2),
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-patch.png",
                        priority = "extra-high",
                        width = 116,
                        height = 128,
                        shift = util.by_pixel(0, -2),
                        scale = 0.5
                    }
                },
                {
                    filename = "__toms-extra-walls__/graphics/entity/shield-wall/wall-patch-shadow.png",
                    priority = "extra-high",
                    width = 74,
                    height = 52,
                    shift = util.by_pixel(8, 14),
                    draw_as_shadow = true,
                    hr_version =
                    {
                        filename = "__toms-extra-walls__/graphics/entity/shield-wall/hr-wall-patch-shadow.png",
                        priority = "extra-high",
                        width = 144,
                        height = 100,
                        shift = util.by_pixel(9, 15),
                        draw_as_shadow = true,
                        scale = 0.5
                    }
                }
            }
        },
    },
} }
