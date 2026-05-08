import '../../domain/models/compendium_item.dart';

final List<CompendiumItem> compendiumSeedData = [
  const CompendiumItem(
    id: 'm1',
    name: 'Goblin',
    type: CompendiumItemType.monster,
    shortDescription: 'Piccolo umanoide malvagio, spesso trovato in gruppi.',
    description: 'I goblin sono creature piccole, nere di cuore ed egoiste che vivono nelle caverne, nelle miniere abbandonate, nei dungeon o in accampamenti ben nascosti in superficie. La loro natura li spinge ad attaccare i più deboli e fuggire dai più forti.',
    metaInfo: 'Sfida 1/4 (50 PE)',
  ),
  const CompendiumItem(
    id: 'm2',
    name: 'Drago Rosso Antico',
    type: CompendiumItemType.monster,
    shortDescription: 'Gargantuesco drago cromatico, caotico malvagio.',
    description: 'L\'odore di zolfo e pomice circonda i draghi rossi. Sono i più avidi di tutti i veri draghi, e si annidano sempre vicino ai loro immensi tesori. Esalano un potentissimo cono di fuoco in grado di incenerire interi eserciti.',
    metaInfo: 'Sfida 24 (62,000 PE)',
  ),
  const CompendiumItem(
    id: 's1',
    name: 'Palla di Fuoco',
    type: CompendiumItemType.spell,
    shortDescription: 'Un bagliore si propaga dal dito puntato fino ad esplodere in fiamme.',
    description: 'Un globo di fuoco esplode con un basso fragore. Ogni creatura in un raggio di 6 metri deve superare un tiro salvezza su Destrezza o subire 8d6 danni da fuoco. Il fuoco danneggia gli oggetti nell\'area e appicca le fiamme agli oggetti infiammabili non indossati.',
    metaInfo: 'Lvl 3 Invocazione',
  ),
  const CompendiumItem(
    id: 's2',
    name: 'Mano Magica',
    type: CompendiumItemType.spell,
    shortDescription: 'Crea una mano spettrale, fluttuante che puoi manipolare a distanza.',
    description: 'Puoi usare la tua azione per controllare la mano. Puoi usarla per manipolare un oggetto, aprire una porta o un contenitore, stivare o recuperare un oggetto. Non può attaccare, attivare oggetti magici o trasportare più di 5 kg.',
    metaInfo: 'Trucchetto Evocazione',
  ),
  const CompendiumItem(
    id: 'i1',
    name: 'Pozione di Cura',
    type: CompendiumItemType.item,
    shortDescription: 'Un liquido rosso scintillante in una piccola fiala.',
    description: 'Chi beve questo liquido magico recupera 2d4 + 2 punti ferita. Bere o somministrare una pozione richiede un\'azione. Il liquido ha un leggero sapore di fragola e metallo.',
    metaInfo: 'Oggetto Comune',
  ),
  const CompendiumItem(
    id: 'i2',
    name: 'Spada Lunga +1',
    type: CompendiumItemType.item,
    shortDescription: 'Una lama letale dall\'aspetto superbo che non perde mai il filo.',
    description: 'Hai un bonus di +1 ai tiri per colpire e ai danni effettuati con quest\'arma magica. In aggiunta, i colpi emettono un leggero ronzio magico udibile solo dal portatore.',
    metaInfo: 'Arma Non Comune',
  ),
];
