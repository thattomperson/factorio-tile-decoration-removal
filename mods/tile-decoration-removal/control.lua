function map(tbl, f)
  local t = {}
  for k,v in pairs(tbl) do
      t[k] = f(v)
  end
  return t
end

script.on_init(function()
  local prototypes = prototypes.get_tile_filtered({{filter = "decorative-removal-probability", comparison = "=", value = 1}})
  names = map(prototypes, function(p) return p.name end)

  for _, surface in pairs(game.surfaces) do
    tiles = surface.find_tiles_filtered({name = names})
    print("Replacing " .. #tiles .. " tiles from surface " .. surface.name)
    surface.set_tiles(
      map(tiles, function (tile) return {name = tile.name, position = tile.position} end)
    )
  end
end)
