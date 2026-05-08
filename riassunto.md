# D&D Companion App - Riassunto Sviluppo

Questo file serve come punto di ripristino per ricordarsi esattamente l'architettura e lo stato del progetto nel caso le conversazioni precedenti andassero perse.

## Cosa è stato sviluppato finora

L'applicazione è una companion app offline-first per D&D, scritta in Flutter, con un focus su modularità, codice pulito e UI dark fantasy moderna (niente blu, ma verde scuro, viola magico, verde naturale e oro).

### 1. Design System e Architettura Base
- **AppColors e AppTheme**: Palette centralizzata e ThemeData configurato per tutta l'app (`lib/core/theme/`).
- **HomeShell**: Layout responsivo radice che gestisce la navigazione. Usa una `NavigationBar` su mobile e una `NavigationRail` su tablet/desktop (`lib/presentation/home/home_shell.dart`).
- **Gestione Stato Navigazione**: Si fa uso di un `IndexedStack` all'interno della shell per preservare lo stato delle schede (evita che la ricerca nel Compendio si resetti cambiando tab).

### 2. Feature: Home Page
La Home page funge da dashboard del giocatore.
- Animazioni fluide (Fade + Slide in ingresso).
- **HeroCard**: Una card principale (Campagna/Personaggio attivo) con design premium e animazione hero.
- **Quick Actions**: Bottoni rapidi (Tira dadi, Incantesimi, ecc.) equamente spaziati.
- **Recent Sessions**: Lista per i riepiloghi delle sessioni.
- **Micro-copy**: Aggiunti testi di supporto ("La tua prossima mossa", "Pronto per tornare nella campagna") per umanizzare la UX.

### 3. Feature: Compendio (Architettura Feature-First)
La pagina Compendio è stata creata per isolare logica, dati e vista in `lib/features/compendium/`.
- **Domain**: Modelli `CompendiumItem` e `CompendiumFilter`. Interfaccia `CompendiumRepository`.
- **Data**: Implementazione finta `CompendiumRepositoryImpl` con cache RAM, che funge da *Single Source of Truth* offline, popolata tramite `compendium_seed_data.dart` (draghi, magie, pozioni).
- **Presentation**: 
  - `CompendiumView` collegata a `CompendiumController` (ChangeNotifier) che gestisce ricerca e filtri in modo pulito e indipendente dalla UI.
  - Widget UI modulari: `CompendiumSearchBar`, `CompendiumCategoryFilters` (Chips reattivi), `CompendiumItemCard`, e un `CompendiumEmptyState`.
  - `CompendiumDetailView`: Pagina di dettaglio accessibile tramite tap sulle card.

## Prossimi Sviluppi (Roadmap)
- **Integrazione API Reale**: Implementazione di un repository remoto collegato a un'API come *D&D 5e API* (in inglese).
- **Miglioramento Filtri**: Aggiunta di un *BottomSheet* per filtri avanzati (Livello, Scuola, CR, Taglia) mantenendo l'interfaccia in italiano ma cercando sui dati in inglese.
- **Database Locale Permanente**: Passaggio dalla cache in RAM a `sqflite` per garantire la persistenza dei dati e supportare l'approccio 100% offline-first reale.
- **Personaggio**: Nuova tab dedicata alla gestione delle statistiche.

---
*Ultimo aggiornamento: Maggio 2026*
