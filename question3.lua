-- This really isn't a very good function name
-- First suggestion would be to change to addRemoveFromPlayerParty
-- It's bad for a few reasons
--  1. It isn't meaningful
--  2. It doesn't have consistent casing
--  3. It doesn't match casing with the rest of the functions I've been provided with

-- Reading the docs, it is possible to create a Player off of either an ID or a name
--  So, I'm going to change these parameter names to be more generic.
-- membername also didn't have consistent casing, so that was bad anyway

function addRemoveFromPlayerParty(playerInfo, memberInfo)
  -- Make everything local as otherwise it can cause global namespace pollution
  local player = Player(playerInfo)
  -- Cache the new member early so we don't do this work every cycle of the loop
  local newMember = Player(memberInfo)
  local party = player:getParty()
  -- Make sure that the new member and party exist before looping
  if (newMember and party) then
    for k,v in pairs(party:getMembers()) do
      if v == newMember then
        party:removeMember(newMember)
        -- Return early so that we don't re-add the member later, or waste loop cycles
        return
      end
    end
    -- Since this function isn't called remove from party, let's
    --  add a member who isn't already in the party
    party:addMember(newMember)
  end
end
