-- @author Narrev
-- Create a searchable table

local find = string.find

local function IsInArray(Array, value)
	for a = 1, #Array do
		if Array[a] == value then
			return true
		end
	end
end

local List = {}
List.__index = List

function List.new(self)
	--- Creates a searchable list
	-- @param table tab An array will be created out of the string indeces

	local Array = {}
	for Index, Value in next, self do
		Array[#Array + 1] = Index
	end
	table.sort(Array)
	self.Array = Array
	return setmetatable(self, List)
end

function List:Search(str)
	local Results = {}
	local Array = self.Array

	for a = 1, #Array do
		local data = Array[a]
		if find(data, "^:" .. str) then
			Results[#Results + 1] = data
		end
	end

	for a = 1, #Array do
		local data = Array[a]
		if find(data, str) and not IsInArray(Results, data) then
			Results[#Results + 1] = data
		end
	end

	return Results
end

return List
