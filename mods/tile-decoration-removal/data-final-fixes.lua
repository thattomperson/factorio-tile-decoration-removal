for k, _ in pairs(data.raw['tile']) do
	if data.raw.tile[k].decorative_removal_probability ~= nil then
		data.raw.tile[k].decorative_removal_probability = 1
	end
end