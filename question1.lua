-- Change: -1 is a magic number, if we're checking it in multiple locations, use a constant instead
--   One problem with this change is that it polutes the global namespace. In the past I've made 
--   global variable holders to avoid poluting the global namespace with multiple constants
releasedData <const> = -1

-- Example of the above note:
-- globals = {}
-- globals.releasedData <const> = -1

-- This function seemed pretty useless to me if it could only clear out a single
--  storage location. 
local function releaseStorage(player, location)
  -- Before: When called, set "1000" to -1
  -- After: When called, set the requested storage location to having been released
  player:setStorageValue(location, releasedData)
end


-- When we log out
function onLogout(player)
  -- Before: If the value of "1000" is 1
  -- Question: Why would we only release the storage if the data is exactly "1"
  --   Doesn't it make more sense instead to release it if it's not in the "initial state"
  --   of -1?
  -- After: If the value of "1000" is NOT released
  if player:getStorageValue(1000) != releasedData then
    -- Before: Then release the storage in 1 second
    -- After: Then release Storage location 1000 in 1 second
    addEvent(releaseStorage, 1000, {player=player, location=1000})
  end
  return true
end
