-- Give players the option to set their preferred role as a tag
-- A 3Ra Gaming creation
-- Modified by I_IBlackI_I

function tag_create_gui(event)
	local player = game.players[event.player_index]
	if not player.gui.top.tag_button then
		player.gui.top.add { name = "tag_button", type = "button", caption = "Tag" }
	end
end

-- Tag list
global.tag = global.tag or {}
global.tag.tags = {
	{ display_name = "Mining" },
	{ display_name = "Oil" },
	{ display_name = "Bus" },
	{ display_name = "Smelting" },
	{ display_name = "Pest Control" },
	{ display_name = "Automation" },
	{ display_name = "Quality Control" },
	{ display_name = "Power" },
	{ display_name = "Trains" },
	{ display_name = "Science" },
	{ display_name = "Robotics"},
	{ display_name = "AFK" },
	{ display_name = "Clear" }
}

function tag_expand_gui(player)
	local frame = player.gui.left["tag-panel"]
	if (frame) then
		frame.destroy()
	else
		local frame = player.gui.left.add { type = "frame", name = "tag-panel", caption = "Choose Tag"}
		local scroll = frame.add { type = "scroll-pane", name = "tag-panel-scroll"}
		scroll.style.maximal_height = 250
		local list = scroll.add { name="tag_table", type = "table", colspan = 1}
		for _, role in pairs(global.tag.tags) do
			list.add { type = "button", caption = role.display_name, name = "tag_" .. role.display_name }
		end
	end
end



function tag_on_gui_click(event)
	if not (event and event.element and event.element.valid) then return end
	local player = game.players[event.element.player_index]
	local name = event.element.name
	if (name == "tag_button") then
		tag_expand_gui(player)
	end

	if (name == "tag_Clear") then
		player.tag = ""
		tag_expand_gui(player)
		return
	end
	
	for _, role in pairs(global.tag.tags) do
		if (name == "tag_" .. role.display_name) then
			player.tag = "[" .. role.display_name .. "]"
			tag_expand_gui(player)
		end
	end
end


Event.register(defines.events.on_gui_click, tag_on_gui_click)
Event.register(defines.events.on_player_joined_game, tag_create_gui)
