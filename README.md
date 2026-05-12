# Vellum
*L'archivio delle tue cronache.*

Vellum è una companion app offline-first per campagne fantasy e giochi di ruolo tabletop (TTRPG). Progettata con un'estetica dark fantasy moderna ed elegante, Vellum è il compagno silenzioso che ti aiuta a tracciare la storia del tuo mondo senza distrazioni.

## 🌙 Filosofia e Tono
Vellum non è una semplice app di note. È un "reperto" digitale.
- **Sobria ed Elegante**: Niente colori sgargianti, niente testi infantili o cliché epici.
- **Materica**: Il linguaggio e l'interfaccia richiamano la pergamena, l'inchiostro e i sigilli.
- **Focalizzata**: Tutto ciò che serve durante una sessione, a portata di mano, senza attriti.

## 🔮 Caratteristiche Principali

### 1. Cronache (Dashboard)
- **Visualizzazione Ottimizzata**: Liste virtualizzate grazie all'uso di `CustomScrollView` e `SliverList` per performance elevate anche con centinaia di elementi.
- **Skeleton Loading**: Effetto shimmer premium (`DndShimmer`) durante il caricamento dei dati per ridurre la percezione dell'attesa.

### 2. Sapere (Compendio)
- **Offline-First**: Accesso rapido ai dati del Compendio con sistema di caching locale.
- **Filtri Avanzati**: Ricerca e consultazione rapida di mostri, incantesimi e oggetti.

### 3. Memorie (Appunti & Gestione)
- **Eroi & Capitoli**: Gestione fluida di personaggi e sessioni di gioco.
- **Reperti (Allegati)**: Supporto per file fisici (immagini, documenti) associati direttamente alle tue note di sessione.

### 4. Backup & Ripristino (`.comp`)
- **Formato Proprietario**: Esporta i tuoi dati in un file unico con estensione `.comp` (un archivio ZIP strutturato con manifest JSON).
- **Supporto Web & Native**: Generazione dell'archivio completamente in memoria per permettere il download su Chrome e il salvataggio classico su Desktop/Mobile.
- **Merge Intelligente**: Durante l'importazione puoi scegliere se sovrascritturare tutto o unire i dati, gestendo automaticamente le collisioni di ID.

## 🛠️ Stack Tecnologico
- **Framework**: Flutter
- **Gestione Stato**: Provider
- **Persistenza**: SharedPreferences (JSON compresso) e File System locale.
- **Formato Archivio**: Package `archive` per la manipolazione dello ZIP.
- **File Picker**: `file_picker` v11.

## 🚀 Come Iniziare
1. Clona il repository.
2. Assicurati di avere Flutter installato.
3. Esegui `flutter pub get` per scaricare le dipendenze.
4. Avvia l'applicazione con `flutter run`.

---
*Fissato nell'inchiostro, protetto dal sigillo.*
