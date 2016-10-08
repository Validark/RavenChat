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

local function IsInArray(Array, value)
	for a = 1, #Array do
		if Array[a] == value then
			return true
		end
	end
end

local find = string.find
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

local Emoji = List.new{
	[":grinning:"] = 509163597;
	[":grin:"] = 509153034;
	[":joy:"] = 509169927; -- :'D
	[":rofl:"] = 509153038;
	[":smiley:"] = 509163552; -- :)
	[":smile:"] = 509153030; -- :D
	[":sweat_smile:"] = 509152986;
	[":laughing:"] = 509153013; -- :satisfied:
	[":wink:"] = 509169929; -- ;)
	[":blush:"] = 509153028;
	[":yum:"] = 509163571;
	[":sunglasses:"] = 509153022; -- 8)
	[":heart_eyes:"] = 509152980;
	[":kissing_heart:"] = 509163614;
	[":kissing:"] = 509163600;
	[":kissing_smiling_eyes:"] = 509163547; -- whistle
	[":kissing_closed_eyes:"] = 509163607;
	[":relaxed:"] = 509163590;
	[":slight_smile:"] = 509153000;
	[":hug:"] = 509152999;
	[":innocent:"] = 509163556;
	[":cowboy:"] = 509152973;
	[":clown:"] = 509152985;
	[":lying:"] = 509152964;
	[":nerd:"] = 509163598;
	[":thinking:"] = 509163570;
	[":neutral_face:"] = 509163586; -- :| ._. '_'
	[":expressionless:"] = 509152995; -- -_-
	[":no_mouth:"] = 509163543;
	[":rolling_eyes:"] = 509163589;
	[":smirk:"] = 509153020;
	[":persevere:"] = 509153010;
	[":disappointed_relieved:"] = 509152972;
	[":open_mouth:"] = 509163555; -- :o
	[":zipper_mouth:"] = 509163587; -- :T
	[":hushed:"] = 509153009;
	[":sleepy:"] = 509163612;
	[":tired_face:"] = 509153019;
	[":sleeping:"] = 509163615;
	[":relieved:"] = 509153033;
	[":stuck_out_tongue:"] = 509153023; -- :P
	[":stuck_out_tongue_winking_eye:"] = 509163581;
	[":stuck_out_tongue_closed_eyes:"] = 509152989;
	[":drooling_face:"] = 509163578;
	[":unamused:"] = 509153005;
	[":sweat:"] = 509163559;
	[":pensive:"] = 509152975;
	[":confused:"] = 509163574; -- :S
	[":upside_down:"] = 509163565;
	[":money_mouth:"] = 509169922;
	[":astonished:"] = 509169936;
	[":mask:"] = 509169928;
	[":thermometer_face:"] = 509163580;
	[":head_bandage:"] = 509163616;
	[":nauseated_face:"] = 509163602; -- :sick:
	[":sneezing_face:"] = 509163599;
	[":frowning2:"] = 509153008;
	[":slight_frown:"] = 509163588;
	[":confounded:"] = 509163613;
	[":disappointed:"] = 509153031;
	[":worried:"] = 509152974;
	[":triumph:"] = 509169926;
	[":cry:"] = 509152988;
	[":sob:"] = 509163557; -- ;(
	[":frowning:"] = 509169923; -- D:
	[":anguished:"] = 509152971;
	[":fearful"] = 509153016; -- D:<
	[":weary:"] = 509163540;
	[":grimacing:"] = 509153012;
	[":cold_sweat:"] = 509163546;
	[":scream:"] = 509152984;
	[":flushed:"] = 509163551;
	[":dizzy_face:"] = 509152963; -- @_@
	[":rage:"] = 509163569;
	[":angry:"] = 509169944;
	[":smiling_imp:"] = 509153004;
	[":imp:"] = 509163564;
	[":egg:"] = 509666168;
	[":gun:"] = 509666113;
}

Emoji:Search("kis")
