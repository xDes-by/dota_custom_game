modifier_builder_tower_repair = class({})

function modifier_builder_tower_repair:IsHidden()
	return false
end

function modifier_builder_tower_repair:IsDebuff()
	return false
end

function modifier_builder_tower_repair:IsStunDebuff()
	return false
end

function modifier_builder_tower_repair:IsPurgable()
	return false
end

function modifier_builder_tower_repair:OnCreated( kv )
	self.hp_repair = self:GetAbility():GetSpecialValueFor( "hp_repair" )
	self.mana_loss = self:GetAbility():GetSpecialValueFor( "mana_loss" )
	self.armor_perc = self:GetAbility():GetSpecialValueFor( "armor_perc" )
	local interval = self:GetAbility():GetSpecialValueFor( "tick_interval" )
	
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex , true, false, 0, false, false )	
	end

	self.hp_repair = self.hp_repair * interval
	self.mana_loss = self.mana_loss * interval
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_tinker_str8")
	if abil ~= nil then
	self.hp_repair = self.hp_repair * 2
	end

	if IsServer() then
		

		self:StartIntervalThink( interval )

		self:PlayEffects()
	end
end

function modifier_builder_tower_repair:OnRefresh( kv )
	
end

function modifier_builder_tower_repair:OnRemoved()
end

function modifier_builder_tower_repair:OnDestroy()
	if not IsServer() then return end

	-- unregister if not forced destroy
	if not self.forceDestroy then
		self:GetAbility():Unregister( self )
	end

	-- instantly kill illusion
	if self:GetParent():IsIllusion() then
		self:GetParent():Kill( self:GetAbility(), self:GetCaster() )
	end
end


function modifier_builder_tower_repair:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_builder_tower_repair:GetModifierPhysicalArmorBonus()
local armor = self:GetParent():GetPhysicalArmorBaseValue()
local true_armor = (armor / 100) * self.armor_perc
	return true_armor
end

--------------------------------------------------------------------------------
function modifier_builder_tower_repair:OnIntervalThink()
	if self:GetParent():IsMagicImmune() or self:GetParent():IsInvulnerable() or self:GetParent():IsIllusion() then
		self:Destroy()
		return
	end

	local hp = self:GetParent():GetHealth()
	local hp_max = self:GetParent():GetMaxHealth()
	
	if hp == hp_max then
	self:Destroy()
	end	
	
	local mana = self:GetCaster():GetMana()
	if mana < self.mana_loss then
	self:Destroy()
	end
	
	

	
	local hp_rep_perc = (hp_max / 100) * self.hp_repair
 	
	self:GetParent():Heal(hp_rep_perc, self:GetParent())
	self:GetCaster():Script_ReduceMana(self.mana_loss, nil)--ReduceMana( self.mana_loss )	
end

--------------------------------------------------------------------------------
function modifier_builder_tower_repair:PlayEffects()
	local particle_cast = "particles/items5_fx/repair_kit.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end