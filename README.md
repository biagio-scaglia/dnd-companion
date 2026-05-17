<div align="center">
  <img src="lib/assets/logo/logo.png" width="300" alt="Vellum Logo">
  <br>
  <i>L'archivio definitivo per le tue campagne RPG.</i>
  <br><br>

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)](https://sqlite.org/index.html)
  [![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](#)
</div>

---

## 📜 Cos'è Vellum?

**Vellum** è un'applicazione companion *offline-first* creata su misura per i giocatori e i Game Master di giochi di ruolo cartacei (TTRPG) come Dungeons & Dragons, Pathfinder e simili. 

Sviluppata con una profonda attenzione per il **design dark fantasy**, Vellum è pensata per essere il tuo compagno silenzioso al tavolo: rapida, immersiva e priva di distrazioni. Tutto ciò che scrivi, crei o tiri appartiene a te e rimane al sicuro sul tuo dispositivo.

---

## ✨ Caratteristiche Principali

### 🎲 Lanciadadi Immersivo (Dice Roller)
Un sistema di lancio dadi rapido e visivamente appagante.
- **Feedback Visivo e Tattile:** Animazioni di "scossa" realistiche dell'interfaccia quando si lanciano i dadi.
- **Risultato Integrato:** Il numero estratto viene stampato dinamicamente sulla faccia del dado specifico (d4, d6, d8, d10, d12, d20, d100).
- **Log Cronologico:** Tracciamento immediato degli "Ultimi Tiri" per non perdere mai il filo dell'azione durante i combattimenti più concitati.

### 🗺️ Cartografia (Map Editor)
Un mini-editor di mappe tile-based completamente integrato nell'app.
- **Griglia Interattiva:** Disegna la struttura dei dungeon (terreni, muri, porte, scale, bauli).
- **Menu Categorizzato:** Un pratico Bottom Sheet suddivide i tile in *Terreni*, *Strutture* e *Speciali* per una costruzione ultra-rapida.
- **Salvataggio Locale:** Le tue mappe non si perdono mai. Progettate per essere accessibili in una frazione di secondo.

### 📚 Il Compendio
Un archivio vastissimo e ricercabile per ogni tua necessità di lore o di regole.
- **Ricerca Istantanea:** Trova Mostri, Incantesimi, Oggetti o Regole in pochi tap.
- **Offline-Ready:** Sfrutta il caching del database per avere le stat-block dei mostri disponibili anche in una taverna senza Wi-Fi.
- **UI Pulita:** Formattazione ottimizzata per leggere i muri di testo tipici dei manuali RPG senza affaticare la vista.

### 📝 Cronache e Memorie (Sessioni & Personaggi)
Sostituisci i fogli volanti con un hub centralizzato.
- **Tracking Eroi & PNG:** Tieni traccia di chiunque incroci il cammino del party.
- **Log di Sessione:** Appunta gli eventi principali, l'oro guadagnato e i punti esperienza.
- **Reperti (Allegati fisici):** Associa immagini, pergamene trovate o documenti direttamente alle tue note di sessione tramite l'integrazione con i file di sistema.

### 📦 Sistema di Backup Intelligente (`.comp`)
I tuoi dati sono sacri. Vellum offre un sistema di esportazione proprietario.
- **Il formato `.comp`:** Un archivio ZIP invisibile all'utente, contenente un manifest JSON, il tuo intero database e le cartelle con tutti i tuoi allegati fisici (immagini).
- **Merge o Sovrascrittura:** Durante l'importazione di un backup, Vellum ti permette di unire i dati (generando nuovi ID per evitare collisioni) o di sostituire in toto la tua libreria attuale.

### 🧭 Guida Interattiva (Onboarding)
- **Coach Marks Adattivi:** Un tutorial elegante ed opzionale che illumina specifici elementi dell'interfaccia (Navigation Bar su Mobile, Navigation Rail su Tablet/Desktop) per spiegare le funzionalità principali ai nuovi avventurieri.

---

## 🛠️ Architettura e Stack Tecnologico

L'applicazione segue i dettami della **Clean Architecture** (seppur adattata per la rapidità di Flutter), dividendo rigorosamente logica di business, accesso ai dati e User Interface.

* **Framework:** Flutter (Dart)
* **Gestione Stato:** `provider` (MultiProvider per l'inversione delle dipendenze).
* **Database & Persistenza:** `sqflite` per i dati relazionali complessi, `shared_preferences` per i toggle e le configurazioni leggere.
* **FileSystem:** `path_provider` per il salvataggio degli allegati immagine, e il package `archive` per la compressione/decompressione dei file `.comp` di backup.
* **Onboarding:** `tutorial_coach_mark` per gestire il tutorial dinamico.
* **Localizzazione (l10n):** Supporto nativo multilingua (Italiano `it` e Inglese `en`) tramite file `.arb`.

### Struttura Directory (Highlight)
```text
lib/
 ├── core/          # Tema (AppColors, AppTypography), Servizi (GuideService)
 ├── features/      # Logica di business (es. map, backup, compendium)
 ├── l10n/          # Traduzioni (.arb)
 ├── presentation/  # UI globale (HomeShell, HomeView, shared widgets)
 └── assets/        # Font (Cinzel, IM Fell), Icone custom, Pack Dadi e Tile
```

---

## 🌐 Localizzazione

Vellum è pronta per l'espansione. Tutte le stringhe di testo, dal tutorial agli alert di cancellazione, sono centralizzate.
Per aggiungere una nuova lingua:
1. Crea un file `app_[lingua].arb` nella cartella `lib/l10n/`.
2. Esegui la build o fai un hot reload.
3. Flutter genererà automaticamente i getter necessari in `AppLocalizations`.

---

## 🚀 Come Iniziare (Per Sviluppatori)

### Prerequisiti
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versione >= 3.x)
- Un editor (VS Code, Android Studio o IntelliJ)

### Installazione

1. **Clona il repository**
   ```bash
   git clone https://github.com/biagio-scaglia/dnd-companion.git
   cd dnd-companion
   ```

2. **Scarica le dipendenze**
   ```bash
   flutter pub get
   ```

3. **Esegui l'app (Debug)**
   ```bash
   flutter run
   ```

### Generare la Release per il Play Store
Vellum è già configurata per la release. Per generare l'AppBundle (`.aab`) ottimizzato:
```bash
flutter build appbundle
```
Il file generato (`app-release.aab`) si troverà in `build/app/outputs/bundle/release/` e sarà pronto per essere caricato sulla Google Play Console.

---

## 🎨 Crediti Design & Risorse

L'estetica di Vellum si basa sul lavoro eccellente di artisti e designer della community:
- **Icone e Tile Mappa:** Creati dal talentuoso [Cainos](https://cainos.itch.io).
- **Tipografia:** La magia prende vita attraverso font iconici come *Cinzel* e *IM Fell English* (Google Fonts).

---

<div align="center">
  <i>Fissato nell'inchiostro, protetto dal sigillo. Buon game.</i>
</div>
