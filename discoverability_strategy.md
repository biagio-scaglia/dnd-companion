# Vellum - Strategia di Discoverability (ASO & SEO)

Questo documento delinea la strategia per massimizzare la visibilità dell'app **Vellum** sugli store (ASO) e sul web (SEO), mantenendo il posizionamento elegante, premium e "soft dark fantasy" richiesto.

---

## 1. Strategia ASO (App Store Optimization)

### App Title & Naming
Il nome "Vellum" è evocativo ma non descrittivo. Dobbiamo affiancare parole chiave forti per gli algoritmi.
*   **Proposta App Store (Max 30 caratteri)**: `Vellum - TTRPG Campaign Notes`
*   **Proposta Google Play (Max 30 caratteri)**: `Vellum: TTRPG Companion & Lore`

### Subtitle / Short Description
Deve spiegare il valore dell'app in una riga, spingendo al download.
*   **App Store Subtitle (Max 30 caratteri)**: `D&D Companion & Lore Tracker`
*   **Google Play Short Description (Max 80 caratteri)**: `The elegant companion for your TTRPG campaigns. Organize notes, lore & characters.`

### Categoria
*   **Primaria**: Intrattenimento (Entertainment) o Utility.
*   **Secondaria**: Riferimento (Reference) o Giochi -> Ruolo (se disponibile come sottocategoria store).

---

## 2. Keyword Research

### Keyword Principali (High Volume, High Competition)
*   *Inglese*: TTRPG, D&D, RPG notes, campaign manager, character sheet, lore tracker.
*   *Italiano*: D&D, GDR, Note D&D, schede personaggio, compendio, master utility.

### Keyword Secondarie (Specifiche per Vellum)
*   *Inglese*: session recap, worldbuilding app, fantasy notes, RPG organizer, spellbook.
*   *Italiano*: diario di sessione, organizzatore campagne, grimorio, app per master.

### Keyword Long-Tail (Meno competitive, alto tasso di conversione)
*   *Inglese*: immersive TTRPG notes app, dark fantasy RPG tracker, D&D lore organizer.
*   *Italiano*: migliore app note sessione GDR, organizzare campagna dnd, compendio offline dnd.

### Keyword da Evitare
*   "Game", "Play" (attirano chi cerca videogiochi, non utility).
*   "Casual", "Simple" (contrastano con il posizionamento premium ed elegante).

---

## 3. Store Metadata Pronti all'Uso

### Apple App Store
*   **Title**: `Vellum - TTRPG Campaign Notes`
*   **Subtitle**: `D&D Companion & Lore Tracker`
*   **Keyword Field (100 char limit)**: `dnd,rpg,ttrpg,campaign,notes,character,compendium,lore,session,dm,utility,organizer,fantasy,sheet`

### Google Play Store
*   **Short Description**: `The elegant companion for your TTRPG campaigns. Organize notes, lore & characters.`
*   **Long Description**:
    ```text
    Step into your next adventure with Vellum, the most immersive and elegant companion app for tabletop RPGs.

    Whether you are playing Dungeons & Dragons, Pathfinder, or your own homebrew system, Vellum helps you track what matters most without breaking the immersion of your fantasy world.

    FEATURES:
    • Elegant Campaign Notes: Organize your sessions, plot points, and discoveries with a clean, dark fantasy interface.
    • Deep Compendium: Access rules, spells, and items quickly. Beautiful pixel-art icons bridge the gap between classic RPG aesthetics and modern usability.
    • Character & NPC Hub: Keep track of your heroes and the allies (or enemies) you meet along the way.
    • Session Logs: Never forget a loot drop or a critical plot twist.

    Designed for players and Game Masters who value both organization and aesthetics. No ads, no clutter, just your story.
    ```

---

## 4. Visual ASO (Screenshot Copy & Struttura)

Gli screenshot devono mostrare l'app dentro un frame elegante (o senza frame ma con sfondi scuri coerenti).

*   **Screenshot 1 (Focus: Compendio)**
    *   *Visual*: La lista del compendio con le bellissime icone pixel art "slot inventario".
    *   *Copy*: `"IL TUO SAPERE. Esplora regole, magie e oggetti con uno stile unico."`
*   **Screenshot 2 (Focus: Note/Sessioni)**
    *   *Visual*: La vista "Memorie" con i capitoli e le note importanti.
    *   *Copy*: `"LA TUA CRONACA. Traccia sessioni, trame e dettagli senza sforzo."`
*   **Screenshot 3 (Focus: Personaggi)**
    *   *Visual*: La lista dei personaggi con la nuova bolla stile RPG.
    *   *Copy*: `"I TUOI EROI. Gestisci personaggi e PNG in un'interfaccia immersiva."`

---

## 5. Posizionamento (USP)

*   **Cosa la distingue**: La maggior parte delle app per note D&D sono o troppo spartane (sembrano fogli Excel) o troppo caotiche. Vellum si posiziona come la scelta **premium ed elegante**. Non urla "geek" con colori neon o font pixelati ovunque; usa una palette calda, icone curate e un layout che rispetta l'atmosfera della sessione attorno al tavolo.
*   **Tagline di posizionamento**: *"Keep the lore, feel the atmosphere."*

---

## 6. SEO Web (Per Flutter Web / Landing Page)

Se pubblichi la versione Web o crei una landing page per l'app:

### Meta Tag (Da inserire nell' `index.html`)
*   **Title**: `Vellum - Elegant TTRPG Campaign Companion & Notes`
*   **Meta Description**: `Organize your D&D and tabletop RPG campaigns with Vellum. Immersive notes, offline compendium, and character tracking with a premium dark fantasy aesthetic.`

### Ottimizzazioni per Flutter Web
Flutter Web genera un'applicazione Single Page (SPA) renderizzata su Canvas o tramite HTML/CSS complessi. Gli spider di Google faticano a indicizzare i contenuti dinamici di Flutter.
*   **Prerendering**: Se crei una landing page, falla in HTML statico o con un framework leggero (non Flutter). Usa Flutter solo per l'app vera e propria.
*   **Sitemap**: Crea una sitemap se la versione web ha pagine accessibili pubblicamente (es. se permetti di condividere una nota via link).
