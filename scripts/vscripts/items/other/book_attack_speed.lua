LinkLuaModifier( "modifier_item_attack_speed_aura", "items/other/book_attack_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_attack_speed_aura_cd", "items/other/book_attack_speed", LUA_MODIFIER_MOTION_NONE )
modifier_item_attack_speed_aura_cd = class({})
function modifier_item_attack_speed_aura_cd:IsHidden() return true end
function modifier_item_attack_speed_aura_cd:IsDebuff() return false end
function modifier_item_attack_speed_aura_cd:IsPurgable() return false end
item_attack_speed_aura = class({})

function item_attack_speed_aura:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.caster:AddNewModifier(self.caster, self, "modifier_item_attack_speed_aura_cd", {duration = self:GetCooldown(self:GetLevel())* self.caster:GetCooldownReduction()})
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
		
		Hero:AddNewModifier(
		self.caster,
		self,
		"modifier_item_attack_speed_aura", 
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
modifier_item_attack_speed_aura = class({})

function modifier_item_attack_speed_aura:IsHidden()
	return false
end

function modifier_item_attack_speed_aura:GetTexture()
	return "scroll_1"
end

function modifier_item_attack_speed_aura:IsDebuff()
	return false
end

function modifier_item_attack_speed_aura:IsPurgable()
	return false
end

function modifier_item_attack_speed_aura:OnCreated( kv )
	if IsServer() then 
		self.caster = self:GetCaster()
		
	end
end

function modifier_item_attack_speed_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		}
	return funcs
end

function modifier_item_attack_speed_aura:GetModifierAttackSpeedBonus_Constant()
	return 50 
end
