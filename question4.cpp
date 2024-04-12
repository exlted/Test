// By refactoring a function out that takes in a Player*, we're able to avoid duplicating this code block
//  while still utilizing it no matter which code path we end up using
void Game::innerAddItemToPlayer(Player* player, uint16_t itemId)
{  
  Item* item = Item::CreateItem(itemId);
  if (!item) {
     return;
  }
  g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
  if (player->isOffline()) {
    IOLoginData::savePlayer(player);
  }
}

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
  Player* player = g_game.getPlayerByName(recipient);
  if (player) {
    innerAddItemToPlayer(player, itemId);
  }
  else 
  {
    // Calling "new" here without a "delete" is what's causing the memory leak
    //player = new Player(nullptr);
    // So, instead of calling new, just make the memory on the stack instead of the heap
    Player tmpPlayer = Player(nullptr);
    if (!IOLoginData::loadPlayerByName(&tmpPlayer, recipient)) {
      return;
    }

    innerAddItemToPlayer(&tmpPlayer, itemId);
  }
}
