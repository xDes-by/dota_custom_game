UniquePortraits = UniquePortraits or class({})

PORTRAITS_FROM_MODEL = {
	["models/items/windrunner/windrunner_arcana/wr_arcana_base.vmdl"] = {
		[1977497166] = "npc_dota_hero_windrunner_alt1",
		[628863847] = "npc_dota_hero_windrunner_alt2",
	},
	["models/items/pudge/arcana/pudge_arcana_base.vmdl"] = {
		[1977497166] = "npc_dota_hero_pudge_alt1",
		[628863847] = "npc_dota_hero_pudge_alt2",
	},
	["models/items/earthshaker/earthshaker_arcana/earthshaker_arcana.vmdl"] = {
		[1977497166] = "npc_dota_hero_earthshaker_alt1",
		[628863847] = "npc_dota_hero_earthshaker_alt2",
	},
	["models/items/wraith_king/arcana/wraith_king_arcana.vmdl"] = {
		[1977497166] = "npc_dota_hero_skeleton_king_alt1",
		[628863847] = "npc_dota_hero_skeleton_king_alt2",
	},
	["models/heroes/juggernaut/juggernaut_arcana.vmdl"] = {
		[1977497166] = "npc_dota_hero_juggernaut_alt1",
		[628863847] = "npc_dota_hero_juggernaut_alt2",
	},
	["models/heroes/lina/lina.vmdl"] = {
		[628863847] = "npc_dota_hero_lina_alt1",
	},
	["models/items/ogre_magi/ogre_arcana/ogre_magi_arcana.vmdl"] = {
		[1977497166] = "npc_dota_hero_ogre_magi_alt1",
		[628863847] = "npc_dota_hero_ogre_magi_alt2",
	},
	["models/items/queenofpain/queenofpain_arcana/queenofpain_arcana.vmdl"] = {
		[1977497166] = "npc_dota_hero_queenofpain_alt1",
		[628863847] = "npc_dota_hero_queenofpain_alt2",
	},
	["models/heroes/legion_commander/legion_commander.vmdl"] = {
		[628863847] = "npc_dota_hero_legion_commander_alt1",
	},
	["models/heroes/pudge_cute/pudge_cute_hook.vmdl"] = "npc_dota_hero_pudge_persona1",
	["models/heroes/antimage_female/antimage_female.vmdl"] = "npc_dota_hero_antimage_persona1",
	["models/heroes/invoker_kid/invoker_kid.vmdl"] = "npc_dota_hero_invoker_persona1",
	["models/items/axe/ti9_jungle_axe/axe_bare.vmdl"] = "npc_dota_hero_axe_alt",
	["models/heroes/phantom_assassin/pa_arcana.vmdl"] = "npc_dota_hero_phantom_assassin_alt1",
	["models/heroes/shadow_fiend/head_arcana.vmdl"] = "npc_dota_hero_nevermore_alt1",
	["models/heroes/terrorblade/terrorblade_arcana.vmdl"] = "npc_dota_hero_terrorblade_alt1",
	["models/heroes/crystal_maiden/crystal_maiden_arcana.vmdl"] = "npc_dota_hero_crystal_maiden_alt1",
	["models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl"] = "npc_dota_hero_monkey_king_alt1",
	["models/items/rubick/rubick_arcana/rubick_arcana_base.vmdl"] = "npc_dota_hero_rubick_alt",
	["models/items/techies/bigshot/bigshot.vmdl"] = "npc_dota_hero_techies_alt1",
	["models/heroes/zeus/zeus_arcana.vmdl"] = "npc_dota_hero_zuus_alt1",
}

function UniquePortraits:Init()
	self.portraits_data = {}
	CustomNetTables:SetTableValue("game", "portraits", self.portraits_data)
end

function UniquePortraits:UpdatePortraitsDataFromPlayer(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if hero then
		local models = {}
		local model = hero:FirstMoveChild()
		local base_model = hero:GetRootMoveParent()
		if base_model then
			table.insert(models, { model_name = base_model:GetModelName(), material = base_model:GetMaterialGroupHash() })
		end
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" or model:GetClassname() == "prop_dynamic" or model:GetClassname() == "additional_wearable" then
				table.insert(models, { model_name = model:GetModelName(), material = model:GetMaterialGroupHash() })
			end
			model = model:NextMovePeer()
		end

		for _, checkModel in pairs(models) do
			local portrait_data = PORTRAITS_FROM_MODEL[checkModel.model_name]
			if portrait_data then
				local portrait_image
				if (type(portrait_data) == 'table') then
					portrait_image = portrait_data[checkModel.material]
				elseif (type(portrait_data) == 'string') then
					portrait_image = portrait_data
				end
				if portrait_image then
					self.portraits_data[player_id] = portrait_image
				end
			end
		end
		CustomNetTables:SetTableValue("game", "portraits", self.portraits_data)
	else
		Timers:CreateTimer(1, function()
			self:UpdatePortraitsDataFromPlayer(player_id)
		end)
	end
end
