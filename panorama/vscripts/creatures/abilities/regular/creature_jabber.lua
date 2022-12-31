LinkLuaModifier("modifier_jabber_attack_animation", "creatures/abilities/regular/creature_jabber", LUA_MODIFIER_MOTION_NONE)

creature_jabber = class({})

function creature_jabber:OnSpellStart()
	if IsServer() then
		if not self.ability_list then
			self.ability_list = {
				"jabber_wild_axes",
				"jabber_earth_splitter",
				"jabber_ghostship",
				"boss_scatterblast",
				"jabber_spear",
				"jabber_hook",
				"jabber_whirling_axes",
				"jabber_firestorm",
				"jabber_laser",
				"jabber_arrow",
				"jabber_eye_of_the_storm",
				"jabber_static_storm",
				"jabber_powershot",
				"jabber_fissure",
				"jabber_arena",
				"creature_flop",
				"creature_timber_chain",
				"creature_breathe_fire",
				"creature_brain_freeze",
				"creature_quill_spray",
				"boss_spawn_spiderling",
				"boss_spawn_baneling",
				"boss_spawn_spiderite",
				"boss_venomous_gale",
				"boss_pounce",
				"boss_icicle",
				"boss_black_hole"
			}

			self.ability_list = table.shuffle(self.ability_list)
		end

		local random_ability = table.remove(self.ability_list)

		self:GetCaster():AddAbility(random_ability):SetLevel(self:GetLevel())

		if self.ability_count then
			self.ability_count = self.ability_count + 1
		else
			self.ability_count = 0
		end

		if self.ability_count >= 12 then
			self:SetActivated(false)
		end
	end
end

function creature_jabber:GetIntrinsicModifierName()
	return "modifier_jabber_attack_animation"
end





modifier_jabber_attack_animation = class({})

function modifier_jabber_attack_animation:IsHidden() return true end
function modifier_jabber_attack_animation:IsDebuff() return false end
function modifier_jabber_attack_animation:IsPurgable() return false end
function modifier_jabber_attack_animation:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_jabber_attack_animation:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ATTACK_START
		}
		return funcs
	end

	function modifier_jabber_attack_animation:OnAttackStart(keys)
		if keys.attacker == self:GetParent() then
			local attack_rate = math.min(4, keys.attacker:GetAttacksPerSecond() * 1.3)
			keys.attacker:StartGestureWithPlaybackRate(ACT_DOTA_NIAN_PIN_START, attack_rate)
		end
	end
end
