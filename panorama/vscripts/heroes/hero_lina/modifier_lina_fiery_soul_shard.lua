---@class modifier_lina_fiery_soul_shard_lua:CDOTA_Modifier_Lua
modifier_lina_fiery_soul_shard_lua = class({})

modifier_lina_fiery_soul_shard_lua.lina_abilities = {
	["lina_fiery_soul"] = true,
	["lina_dragon_slave"] = true,
	["lina_light_strike_array"] = true,
	["lina_laguna_blade"] = true,
}

function modifier_lina_fiery_soul_shard_lua:IsHidden() return true end
function modifier_lina_fiery_soul_shard_lua:IsPurgable() return false end
function modifier_lina_fiery_soul_shard_lua:RemoveOnDeath() return false end

function modifier_lina_fiery_soul_shard_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_lina_fiery_soul_shard_lua:OnCreated()
	if IsClient() then return end

	self.last_hit_time = {}
end

function modifier_lina_fiery_soul_shard_lua:GetModifierTotalDamageOutgoing_Percentage(params)
	if self.lock then return end

	local inflictor = params.inflictor
	local parent = params.attacker
	local target = params.target
	
	if not inflictor then return end
	if inflictor:IsItem() then return end
	if self.lina_abilities[inflictor:GetAbilityName()] then return end

	local stack_count = parent:GetModifierStackCount("modifier_lina_fiery_soul", parent)
	local damage = stack_count * 10
	local cooldown = 1
	
	local current_time = GameRules:GetGameTime()
	local last_hit_time = self.last_hit_time[target:entindex()]
	
	local is_cooldown_ended = not last_hit_time or last_hit_time + cooldown <= current_time

	if damage > 0 and is_cooldown_ended then
		self.lock = true
		ApplyDamage({
			victim = target,
			attacker = parent,
			ability = inflictor,
			damage = damage,
			damage_type = params.damage_type
		})
		self.lock = nil

		parent:FindModifierByName("modifier_lina_fiery_soul"):SetStackCount(stack_count)

		self.last_hit_time[target:entindex()] = current_time
	end

end