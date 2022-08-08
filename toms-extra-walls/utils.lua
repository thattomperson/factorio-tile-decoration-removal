function config(name, mod_name)
  return settings.startup[ (mod_name or 'toms-extra-walls') .. ':' .. name].value
end

--And these two make defining common file paths much shorter.
function sprite(name, mod_name)
  return '__' .. (mod_name or 'toms-extra-walls') .. '__/sprite/' .. name
end

function sound(name, mod_name)
  return '__' .. (mod_name or 'toms-extra-walls') .. '__/sound/' .. name
end

function recipe(name, mod_name)
  return  (mod_name or 'toms-extra-walls') .. ':' .. name .. '-recipe'
end

function entity(name, mod_name)
  return  (mod_name or 'toms-extra-walls') .. ':' .. name .. '-entity'
end

function item(name, mod_name)
  return  (mod_name or 'toms-extra-walls') .. ':' .. name .. '-item'
end

function tech(name, mod_name)
  return  (mod_name or 'toms-extra-walls') .. ':' .. name .. '-technology'
end
