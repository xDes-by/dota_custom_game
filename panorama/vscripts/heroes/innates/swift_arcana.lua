innate_swift_arcana = class({})

LinkLuaModifier("modifier_innate_swift_arcana", "heroes/innates/swift_arcana", LUA_MODIFIER_MOTION_NONE)

function innate_swift_arcana:GetIntrinsicModifierName()
	return "modifier_innate_swift_arcana"
end





modifier_innate_swift_arcana = class({})

function modifier_innate_swift_arcana:IsHidden() return true end
function modifier_innate_swift_arcana:IsDebuff() return false end
function modifier_innate_swift_arcana:IsPurgable() return false end
function modifier_innate_swift_arcana:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_swift_arcana:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_swift_arcana:OnPvpEndedForDuelists(keys)
	local parent = self:GetParent()
	local cooldown_reduction = (100 - self:GetAbility():GetSpecialValueFor("ability_cd_reduction")) / 100.0
	
	Timers:CreateTimer(0.5, function()
		if parent and (not parent:IsNull()) then
			parent:EmitSound("DOTA_Item.Refresher.Activate")

			local refresh_pfx = ParticleManager:CreateParticle("particles/custom/innates/swift_arcana.vpcf", PATTACH_POINT_FOLLOW, parent)
			ParticleManager:SetParticleControlEnt(refresh_pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(refresh_pfx)

			for i = 0, (DOTA_MAX_ABILITIES - 1) do
				local ability = parent:GetAbilityByIndex(i)
				if ability and (not ability:IsNull()) then
					local cooldown = ability:GetCooldownTimeRemaining()
					ability:EndCooldown()
					ability:StartCooldown(cooldown * cooldown_reduction)  -- removing 75% cd (multiplying by 0.25)
				end
			end

			for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_NEUTRAL_SLOT do -- 0-8 inventory, 9-14 stash, 15 - tp scroll, 16 - neutral slot
				if i < 9 or i > 15 then
					local item = parent:GetItemInSlot(i)
					if item and (not item:IsNull()) then
						local cooldown = item:GetCooldownTimeRemaining()
						item:EndCooldown()
						item:StartCooldown(cooldown * cooldown_reduction)
					end
				end
			end
		end
	end)
end
