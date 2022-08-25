LinkLuaModifier( "modifier_item_hp_aura", "items/other/book_hp", LUA_MODIFIER_MOTION_NONE )

item_hp_aura = class({})

function item_hp_aura:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
		
		Hero:AddNewModifier(
		self.caster,
		self,
		"modifier_item_hp_aura", 
		{duration = self.duration})
		end
			self.caster:EmitSound("Item.TomeOfKnowledge")
			self:SpendCharge()
			local new_charges = self:GetCurrentCharges()
			if new_charges <= 0 then
			self.caster:RemoveItem(self)
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_item_hp_aura = class({})

function modifier_item_hp_aura:IsHidden()
	return false
end

function modifier_item_hp_aura:GetTexture()
	return "scroll_5"
end

function modifier_item_hp_aura:IsDebuff()
	return false
end

function modifier_item_hp_aura:IsPurgable()
	return false
end

function modifier_item_hp_aura:OnCreated( kv )
	if IsServer() then 
		self.caster = self:GetCaster()
		
	end
end

function modifier_item_hp_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		}
	return funcs
end

function modifier_item_hp_aura:GetModifierHealthRegenPercentage()
	return 2 
end
