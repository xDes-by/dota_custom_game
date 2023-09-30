ability_npc_boss_barrack2_spell2 = class({})

function ability_npc_boss_barrack2_spell2:OnSpellStart()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 2, false)
    if enemies[1] then
        local projectile = {
            Target 				= enemies[1],
            Source 				= self:GetCaster(),
            Ability 			= self,
            EffectName 			= "particles/items_fx/ethereal_blade.vpcf",
            iMoveSpeed			= 800,
            bDrawsOnMinimap 	= false,
            bDodgeable 			= true,
            ExtraData = {type = "etherial"}
        }	
        ProjectileManager:CreateTrackingProjectile(projectile)
        local info1 = {
            Source = self:GetCaster(),
            Ability = self,	
            
            EffectName = "particles/units/heroes/hero_morphling/morphling_adaptive_strike_agi_proj.vpcf",
            iMoveSpeed = 550,
            bDodgeable = true,                           -- Optional
            Target = enemies[1],
            
            bDrawsOnMinimap = false,                          -- Optional
            bVisibleToEnemies = true,                         -- Optional
            ExtraData = {type = "agi"}
        }
        ProjectileManager:CreateTrackingProjectile(info1)
        EmitSoundOn("DOTA_Item.EtherealBlade.Activate", self:GetCaster())
        EmitSoundOn("Hero_Morphling.AdaptiveStrikeAgi.Cast", self:GetCaster())
    end
    Timers:CreateTimer(0.3,function()
        if enemies[2] then
            local projectile = {
                Target 				= enemies[1],
                Source 				= self:GetCaster(),
                Ability 			= self,
                EffectName 			= "particles/items_fx/ethereal_blade.vpcf",
                iMoveSpeed			= 800,
                bDrawsOnMinimap 	= false,
                bDodgeable 			= true,
                ExtraData = {type = "etherial"}
            }	
            ProjectileManager:CreateTrackingProjectile(projectile)
            local info2 = {
                Source = self:GetCaster(),
                Ability = self,	
                
                EffectName = "particles/units/heroes/hero_morphling/morphling_adaptive_strike_str_proj.vpcf",
                iMoveSpeed = 550,
                bDodgeable = true,                           -- Optional
                Target = enemies[2],
                
                bDrawsOnMinimap = false,                          -- Optional
                bVisibleToEnemies = true,                         -- Optional
                ExtraData = {type = "str"}
            }
            ProjectileManager:CreateTrackingProjectile(info2)
            EmitSoundOn("Hero_Morphling.AdaptiveStrikeStr.Cast", self:GetCaster())
        end    
    end)
end

function ability_npc_boss_barrack2_spell2:OnProjectileHit_ExtraData(hTarget, vLocation, table)
    if table.type == "etherial" then
        ApplyDamage({victim = hTarget,
        damage = self:GetSpecialValueFor("etherial_damage") * 0.02 * hTarget:GetMaxHealth() ,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self})
        EmitSoundOn("DOTA_Item.EtherealBlade.Target", self:GetCaster())
    end
    if table.type == "agi" then
        ApplyDamage({victim = hTarget,
        damage = self:GetSpecialValueFor("agi_damage") * 0.02 * hTarget:GetMaxHealth() ,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self})
        EmitSoundOn("Hero_Morphling.AdaptiveStrikeAgi.Target", self:GetCaster())
    end
    if table.type == "str" then
        ApplyDamage({victim = hTarget,
        damage = self:GetSpecialValueFor("str_damage") * 0.02 * hTarget:GetMaxHealth() ,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self})
        hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("str_stun_duration")})
        EmitSoundOn("Hero_Morphling.AdaptiveStrikeStr.Target", self:GetCaster())
    end
end