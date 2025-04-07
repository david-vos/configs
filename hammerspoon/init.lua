local spaces = require("hs.spaces")
local window = require("hs.window")
local screen = require("hs.screen")

function switchSpace(spaceIndex)
	local win = window.focusedWindow()
	if not win then
		hs.alert.show("No focused window")
		return
	end

	local scr = win:screen()
	if not scr then
		hs.alert.show("No screen found")
		return
	end

	local screenUUID = scr:getUUID()
	local allSpaces = spaces.allSpaces()

	if not allSpaces then
		hs.alert.show("Error retrieving spaces")
		return
	end

	local spaceList = allSpaces[screenUUID]
	if not spaceList then
		hs.alert.show("No spaces found for this screen")
		return
	end

	local spaceID = spaceList[spaceIndex]
	if not spaceID then
		hs.alert.show("Space index " .. spaceIndex .. " not found on this screen")
		return
	end

	local success, err = spaces.gotoSpace(spaceID)
	if not success then
		hs.alert.show("Error switching space: " .. err)
	else
		hs.alert.show("Switched to space " .. spaceIndex .. " on this screen")
	end
end

-- Bind hotkeys to ctrl+cmd+0 through ctrl+cmd+9
for i = 0, 9 do
	hs.hotkey.bind({"ctrl", "cmd"}, tostring(i), function()
		switchSpace(i)
	end)
end

hs.alert.show("Hammerspoon loaded with multi-monitor space switching")

