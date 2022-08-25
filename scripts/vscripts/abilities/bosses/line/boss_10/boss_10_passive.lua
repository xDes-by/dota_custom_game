LinkLuaModifier("modifier_boss_10_passive", "abilities/bosses/line/boss_10/boss_10_passive", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_10_move", "abilities/bosses/line/boss_10/boss_10_passive", LUA_MODIFIER_MOTION_NONE)

boss_10_passive = class({})

function boss_10_passive:GetIntrinsicModifierName()
	return "modifier_boss_10_passive"
end

----------------------------------------------------------------------------------

modifier_boss_10_passive = class({})

function modifier_boss_10_passive:IsHidden()
    return true
end

function modifier_boss_10_passive:OnCreated()
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self:StartIntervalThink(self.interval)
	
end


function modifier_boss_10_passive:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster():IsAlive() then return end
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 1 then
		for _, enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsAlive() then
			local distance = ( enemy:GetOrigin() - self:GetCaster():GetOrigin() ):Length2D()
				if distance > 200 then
					self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boss_10_move", {duration = 0.5})
					self:cast_move(enemy)
				end
			end
		end	
	end
end

function modifier_boss_10_passive:cast_move(target)
	self:GetCaster():EmitSound("Hero_EmberSpirit.FireRemnant.Explode")	
	GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), 300, false)
	ProjectileManager:ProjectileDodge(self:GetCaster())
	FindClearSpaceForUnit(self:GetCaster(), target:GetAbsOrigin(), true)
	self:GetCaster():EmitSound("Hero_EmberSpirit.FireRemnant.Stop")
	self:GetCaster():SetForceAttackTarget( target )
	self:GetCaster():SetForceAttackTarget( nil )
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then
		for _, enemy in pairs( enemies ) do
			self.damageTable = {
			attacker = self:GetCaster(),
			victim = enemy,
			damage = self:GetAbility():GetSpecialValueFor("damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage( self.damageTable )
		end
	end
end

--------------------------------------------------------------
modifier_boss_10_move = class ({})

function modifier_boss_10_move:IsDebuff() return false end
function modifier_boss_10_move:IsHidden() return true end
function modifier_boss_10_move:IsPurgable() return false end

function modifier_boss_10_move:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf"
end

function modifier_boss_10_move:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_10_move:CheckState()
	if IsServer() then
		return {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true
		}
	end
end