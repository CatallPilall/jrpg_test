

Globale klassen laden als erstes:

- Logger
- EventBus
- InputHandler
- SceneLoader
- MusicPlayer
- SfxPlayer
- TimerGlobal
- TeamRoster

Diese Klassen werden am Anfang Init!!

Danach werden alle Set values aufgerufen (über den @export -> siehe unit ressource)
(zbsp. werden dadurch die stats für die units gesetzt)


### Ablauf

-> Main wird geladen
-> Main initialisiert sfx/muisc-player
-> sceneloader wird initialisied
	-> sceneloader lädt alle uis
	-> alle setter werden geladen (von den scenen, die geladen werden) (campaign_menu hat units,  die geladen werden (unit_attributs set))
	-> alle level scenen geladen (set atributes für gegner, da diese auch existieren in level (overworld))
-> Button onklick event abgewartet
-> entsprechend verschiedene menüs geladen
-> und rest kommt noch (andere prio momentan)