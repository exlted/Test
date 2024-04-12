function printSmallGuildNames(memberCount)
  -- this method is supposed to print names of all guilds that have less than memberCount max members
  local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
  -- Makes a query that stores into result (accessible referencing resultId)
  local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
  -- Before: This is wrong, for one, it doesn't reference resultId
  --  Additionally, it doesn't free the memory from the query
  --  Third of all, it doesn't loop over anything, so this will only print 1 name

  repeat
  {
    local guildName = result.getDataString(resultId, "name")
    print(guildName)
  } until (!result.next(resultId))

  result.free(resultId)
end
