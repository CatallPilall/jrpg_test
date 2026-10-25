# Wichtige TODOs – JRPG Projekt (Godot)

Technische Dokumentation und Aufarbeitung des Projekts.

## UI & Abläufe
- [ ] **Graphen für UI-States** – Zustandsdiagramme der Menüs (Main Menu, In-Game Menu, Battle UI, Inventory, Dialogue) mit Übergängen und Bedingungen
- [ ] **Ablauf der Spielschleife (Map-Phase)** – Bewegung auf der Karte, Trigger für Kämpfe/Events, Übergang in den rundenbasierten Battle-Modus (Game Loop ist hier weniger zentral, da Kämpfe rundenbasiert)

## Architektur
- [ ] **Wichtige Klassen und deren Funktionen** – Übersicht aller zentralen Klassen (Player, Enemy, BattleManager, SceneManager, Inventory, …) mit Methoden und Verantwortlichkeiten
- [ ] **Events** – Event-System dokumentieren: welche Events existieren, wer sie sendet/empfängt, Payloads
- [ ] **Ressourcen (Godot)** – Godot-Ressourcen (.tres, .res, Scenes, Daten-JSON) und wie sie geladen/verwaltet werden (ResourceLoader, vorladen, Caching) 
- [ ] **SceneTree** – Szenenstruktur, Hierarchie der Nodes, Lebenszyklus (ready, process, exit), Autoloads/Singletons

## Zusammenhänge
- [ ] **Zusammenhänge zwischen Klassen und Funktionen** – Abhängigkeitsgraph, wer wen aufruft, Datenfluss zwischen Systemen (besonders Map ↔ Battle)

## Inhalt
- [ ] **Story** – Handlung, Kapitel, Quests, Charaktere, Dialoge und Verzweigungen
