local mod = {}

function mod.concat(table1, table2)
	local result = {}

	for _, value in ipairs(table1) do
		table.insert(result, value)
	end

	for _, value in ipairs(table2) do
		table.insert(result, value)
	end

	return result -- Return the concatenated table
end

return mod
