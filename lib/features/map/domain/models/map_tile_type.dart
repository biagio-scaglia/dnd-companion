enum MapTileType {
  // Pavimenti
  floorStone,
  floorWood,
  floorDirt,
  
  // Muri
  wallStone,
  wallWood,
  
  // Ostacoli e Scenari
  water,
  lava,
  doorClosed,
  doorOpen,
  stairsUp,
  stairsDown,
  
  // Oggetti base
  chest,
  table,
  barrel;

  // Una piccola utility per sapere se è solido (non attraversabile di default)
  bool get isSolid {
    return this == wallStone || 
           this == wallWood || 
           this == doorClosed || 
           this == barrel || 
           this == table ||
           this == chest;
  }
}
