local spell = Spell("instant")

local dist = 7
local UNWANTED_TILESTATES = { TILESTATE_PROTECTIONZONE, TILESTATE_HOUSE, TILESTATE_FLOORCHANGE, TILESTATE_TELEPORT, TILESTATE_BLOCKSOLID, TILESTATE_BLOCKPATH }

local function moveTo(params)
	local creature = Creature(params[1])
	creature:move(params[2])
	
	for i=1,#params[3] do
	  if i < params[4] + 1 then
	    local ghost = Creature(params[3][i])
		ghost:move(params[2])
	  end
	end
end

local function cleanUp(idsToClean)
	for i=1,#idsToClean do
	  local creature = Creature(idsToClean[i])
	  if creature then
	    creature:remove()
	  end
	end
end

local function setSpeed(params)
	local creature = Creature(params[1])
	creature:changeSpeed(params[2])
end

local function sendExtendedOpcode(params)
	local pos = getThingPos(params[1])
	local players = Game:getSpectators(pos, false, false, 0, 0, 20, 20)
	-- getSpectators doesn't seem to include the player on that tile, so add it here
	local creature = Creature(params[1])
	table.insert(players, creature)
	
	local buffer  = creature:getId()..","..params[2]
	for j=1,#params[3] do
	  buffer = buffer..","..params[3][j]
	end
	
	for i=1,#players do
		local player = players[i]:getPlayer()
		if (player) then
			player:sendExtendedOpcode(14, buffer)
		end
	end
end

function spell.onCastSpell(cid, variant)
  local creature, pos = Creature(cid), getThingPos(cid)
  local dir = creature:getDirection()
  local nextDashPos = pos;
  local dashedDist = 0;
  local player = Player(creature)
  for i=1,dist do
	local continue = true;
    nextDashPos:getNextPosition(dir, 1)
	local tile = Tile(nextDashPos)
	for _,flag  in pairs(UNWANTED_TILESTATES) do
		if (tile:hasFlag(flag)) then
			continue = false;
			break;
		end
	end
	if not continue then
		break;
	end
    dashedDist = i
  end

  if (dashedDist ~= dist) then
    if (player) then
      player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "You can't dash any further.")
	end
  end
  if (dashedDist == 0) then
    return false
  end

  local initialSpeed = creature:getSpeed()
  creature:changeSpeed(initialSpeed * 2)
  
  -- Get Player Outfit
  local outfit = player:getOutfit()
  -- Create Ghost Players (new opcode?)
  local ghostIds = {}
  for i=1,4 do
    local ghost = Game.createNpc("Ghost", getThingPos(cid), false, true, CONST_ME_NONE)
    ghostIds[i] = ghost:getId()
	ghost:changeSpeed(initialSpeed * 2)
	ghost:setOutfit(outfit)
	ghost:setDirection(dir)
  end
  -- Move Ghost Players tiles behind real player

  -- Before starting movement, enable opcode on spectators to turn on shader
  sendExtendedOpcode({cid, 1, ghostIds})
  
  for i=0,dashedDist-1 do
	addEvent(moveTo, i * 100, {cid, dir, ghostIds, i})
  end
  addEvent(setSpeed, dashedDist * 100, {cid, initialSpeed})
  
  -- After finishing movment disable opcode on spectators to turn off shader
  addEvent(sendExtendedOpcode, dashedDist * 100, {cid, 0, {}})
  -- Delete Ghost Players alongside clearing out the Dash shader on the clients
  addEvent(cleanUp, dashedDist * 100, ghostIds)
  return true;
end

spell:name("Dash")
spell:words("dash")
spell:group("support")
spell:vocation("sorcerer")
spell:cooldown(1 * 1000)
spell:groupCooldown(.5 * 1000)
spell:level(0)
spell:mana(1)
spell:isSelfTarget(true)
spell:isPremium(false)
spell:register()
