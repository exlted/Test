-- Constants to easily modify the graphics of the spell
MAJOR_SPELL = 82 -- Custom, Somehow I broke the built in one... I think
MINOR_SPELL = 81 -- Custom, Added as the texture didn't seem to be available in the packs I had available

-- Spell Definitions
-- x: Relative X Position to the Caster for the spell efffect
-- y: Relative Y Position to the Caster for the spell effect
-- spellEffect: ID for the graphics to be shown at the specified location
SPELL_GROUP_1 = {
	{x = 2, y = 1, spellEfffect = MINOR_SPELL},
	{x = 2, y = -1, spellEfffect = MINOR_SPELL},
	{x = 0, y = -3, spellEfffect = MINOR_SPELL},
	{x = -3, y = 0, spellEfffect = MAJOR_SPELL},
	{x = 3, y = 0, spellEfffect = MAJOR_SPELL}
}

SPELL_GROUP_2 = {
	{x = -2, y = 1, spellEfffect = MINOR_SPELL},
	{x = -2, y = -1, spellEfffect = MINOR_SPELL},
	{x = 0, y = -1, spellEfffect = MINOR_SPELL},
	{x = 1, y = 2, spellEfffect = MAJOR_SPELL},
	{x = -1, y = 2, spellEfffect = MAJOR_SPELL}
}

SPELL_GROUP_3 = {
	{x = 0, y = 1, spellEfffect = MINOR_SPELL},
	{x = 0, y = 3, spellEfffect = MINOR_SPELL}
}

SPELL_GROUP_4 = {
	{x = 1, y = 0, spellEfffect = MAJOR_SPELL},
	{x = -1, y = -2, spellEfffect = MAJOR_SPELL},
	{x = -1, y = 0, spellEfffect = MAJOR_SPELL}
}

SPELL_GROUP_5 = {
	{x = 1, y = -2, spellEfffect = MAJOR_SPELL},
	{x = 1, y = -2, spellEfffect = MAJOR_SPELL}
}

-- doSpellEffects --
-- Takes an array of Spell Groups (listed above) and renders them to the screen
function doSpellEffects(position, effectArrays)
	for i=1, #effectArrays do
		for j=1, #effectArrays[i] do
			local relativePosition = Position(position.x + effectArrays[i][j].x, position.y + effectArrays[i][j].y, position.z)
			relativePosition:sendMagicEffect(effectArrays[i][j].spellEfffect)
		end
	end
end

-- onCastSpell --
-- Function that gets called into when the spell is triggered by a creature
function onCastSpell(creature, var)
	local position = Creature(creature):getPosition()
	-- Video at 24 FPS. One Frame ~= 41.667 ms
	doSpellEffects(position, {SPELL_GROUP_1, MAJOR_SPELL_GROUP_4})
	addEvent(doSpellEffects, 292, position, {SPELL_GROUP_2}) -- 0 + 7 frames`
	addEvent(doSpellEffects, 500, position, {SPELL_GROUP_4}) -- 0 + 12 frames
	addEvent(doSpellEffects, 833, position, {SPELL_GROUP_3}) -- 0 + 20 frames
	addEvent(doSpellEffects, 1000, position, {SPELL_GROUP_1, SPELL_GROUP_5}) -- 1000 + 0 frames
	addEvent(doSpellEffects, 1292, position, {SPELL_GROUP_2}) -- 1000 + 7 frames
	addEvent(doSpellEffects, 1500, position, {SPELL_GROUP_4}) -- 1000 + 12 frames
	addEvent(doSpellEffects, 1792, position, {SPELL_GROUP_3}) -- 1000 + 19 frames
	addEvent(doSpellEffects, 2000, position, {SPELL_GROUP_1, SPELL_GROUP_5}) -- 2000 + 0 frames 
	addEvent(doSpellEffects, 2292, position, {SPELL_GROUP_2}) -- 2000 + 7 frames
	addEvent(doSpellEffects, 2500, position, {SPELL_GROUP_4, SPELL_GROUP_5}) -- 2000 + 12 frames
	addEvent(doSpellEffects, 2792, position, {SPELL_GROUP_3}) -- 2000 + 19 frames
	
    return true
end