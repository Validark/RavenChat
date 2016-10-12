-- Emoji maker
-- @author Narrev
-- @source Windows 10 aniversary

-- Config
local EmojiSize = UDim2.new(0, 18, 0, 18)

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Nevermore"))
local List = require "List"

-- Emoji Object
local Emoji = List.new{ -- ArialBold Size14 version
	[":grinning:"] = 518829060;
	[":grin:"] = 518829058;
	[":joy:"] = 518828296; -- :'D
	[":rofl:"] = 518827570;
	[":smiley:"] = 518831706; -- :)
	[":smile:"] = 518829100; -- :D
	[":sweat_smile:"] = 518829080;
	[":laughing:"] = 518827571; -- :satisfied:
	[":wink:"] = 518829089; -- ;)
	[":blush:"] = 518828319;
	[":yum:"] = 518829518;
	[":sunglasses:"] = 518831720; -- 8)
	[":heart_eyes:"] = 518827557;
	[":kissing_heart:"] = 518827550;
	[":kissing:"] = 518827573;
	[":kissing_smiling_eyes:"] = 518829525; -- whistle
	[":kissing_closed_eyes:"] = 518828299;
	[":relaxed:"] = 518828319;
	[":slight_smile:"] = 518828328;
	[":hug:"] = 518828326;
	[":innocent:"] = 518829078;
	[":cowboy:"] = 518828293;
	[":clown:"] = 518829054;
	[":lying:"] = 518829082;
	[":nerd:"] = 518829513;
	[":thinking:"] = 518829522;
	[":neutral_face:"] = 518829067; -- :| ._. '_'
	[":expressionless:"] = 518829036; -- -_-
	[":no_mouth:"] = 518827554;
	[":rolling_eyes:"] = 518827574;
	[":smirk:"] = 518829035;
	[":persevere:"] = 518829512;
	[":disappointed_relieved:"] = 518828312;
	[":open_mouth:"] = 518831705; -- :o
	[":zipper_mouth:"] = 518829102; -- :T
	[":hushed:"] = 518827582;
	[":sleepy:"] = 518829069;
	[":tired_face:"] = 518827556;
	[":sleeping:"] = 518827583;
	[":relieved:"] = 518829056;
	[":stuck_out_tongue:"] = 518828305; -- :P
	[":stuck_out_tongue_winking_eye:"] = 518829093;
	[":stuck_out_tongue_closed_eyes:"] = 518829073;
	[":drooling_face:"] = 518831725;
	[":unamused:"] = 518828294;
	[":sweat:"] = 518828320;
	[":pensive:"] = 518828332;
	[":confused:"] = 518828314; -- :S
	[":upside_down:"] = 518829053;
	[":money_mouth:"] = 518827575;
	[":astonished:"] = 518829072;
	[":mask:"] = 518827560;
	[":thermometer_face:"] = 518829071;
	[":head_bandage:"] = 518831726;
	[":nauseated_face:"] = 518925125; -- :sick:
	[":sneezing_face:"] = 518828329;
	[":frowning2:"] = 518829091;
	[":slight_frown:"] = 518827549;
	[":confounded:"] = 518828308;
	[":disappointed:"] = 518831708;
	[":worried:"] = 518831712;
	[":triumph:"] = 518829034;
	[":cry:"] = 518829514;
	[":sob:"] = 518828310; -- ;(
	[":frowning:"] = 518828321; -- D:
	[":anguished:"] = 518827555;
	[":fearful"] = 518829072; -- D:<
	[":weary:"] = 518829057;
	[":grimacing:"] = 518828333;
	[":cold_sweat:"] = 518831722;
	[":scream:"] = 518829096;
	[":flushed:"] = 518827578;
	[":dizzy_face:"] = 518829519; -- @_@
	[":rage:"] = 518827558;
	[":angry:"] = 518828295;
	[":smiling_imp:"] = 518831711;
	[":imp:"] = 518829095;
	[":egg:"] = 518828306;
	[":gun:"] = 518829090;
}

function Emoji.new(str, Parent)
	--- Creates new Emoji with Instance.new syntax
	-- @param str the name of the Emoji
	-- @param RobloxObject Parent the second argument for Instance.new
	-- @returns ImageLabel Emoji

	local emoticon = Instance.new("ImageLabel", Parent)
	emoticon.BackgroundTransparency = 1
	emoticon.Image = "rbxassetid://" .. Emoji[str]
	emoticon.Name = str
	emoticon.Size = EmojiSize
	emoticon.ZIndex = 9
	return emoticon
end

return Emoji
