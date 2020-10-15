#### 9.0.0
* Updated for Shadowlands.

##### 8.3.2
* Retail: fixed issue with some allied race icons.
* Retail: fixed tooltip issues with caged pets and keystones.
* Retail: fixed search issue with champion/follower equipment.

##### 8.3.1
* All
    * Fixed issues with rulesets.
    * Fixed visual issue with ruleset configuration.
    * Updated Chinese localization (by Adavak).
    * Updated Korean localization (by chkid).
* Retail
    * Added recent races.
    * Fixed issue making dropdowns unclickable.

#### 8.3.0
* Updated for Visions of Nzoth.
* General
    * New owner selection menu.
    * New frame selection menu.
    * New icons in interface options.
    * Upgraded interface options color picker design.
    * Now, if no plugins like `Combuctor Scrap` are installed, optionally marks sellable gray items with the default junk coin icon.
    * Added some backwards compatibility for out of date plugins.
    * Fixed issue with reappearing inactive widgets on scrollable menus.
    * Fixed bug with data-broker display region.
* Retail
    * Now void storage and guild bank properly support _Flash Find_.
    * Fixed multiple bugs with void storage.
* Classic
    * Added keyring.
    * Added key sorting.
* Internal changes
    * Upgraded to Poncho-2.0 and Sushi-3.1.
    * Reorganization of components shared functionality using Poncho-2.0 new features.
    * Massive cleaning and standardizing of code into Ace-like modules using WildAddon-1.0.
    * Moved internally used timer API to new library DelayMutex-1.0.
    * No longer using taintable dropdown or static popup implementations.

##### 8.2.10
* Sorting now even faster in most situations.
* Updated Korean localization (by chkmyid).
* Updated Taiwanese localization (by kalvin807).

##### 8.2.9
* Sorting now much faster in most situations.

##### 8.2.8
* Removed _Heirloom_ item filter on classic servers.
* Fixed 2 sorting bugs, causing sorting to stop or enter a loop on very specific conditions on classic servers.
* Fixed issue with some container tooltips.
* Fixed small visual bug.
* Fixed issue with Spanish, French, Italian, Portuguese and Russian localization.
* Updated Chinese localization.

##### 8.2.7
* Can now sort items, even if the server doesn't support it:
    * Bags and bank in classic.
    * Void storage in retail.
    * Sorting stops if entering combat.
* Bugfixes:
    * Tooltip counts now properly include items in the 1st bank slot.
    * Fixed issue depositing items in the reagent bank.
    * Fixed rare issue sorting the reagent bank.
    * Fixed issue with button generation on classic servers, preventing frames from being disabled.
* Localization:
    * Updated Chinese locales.
    * Changed how tooltip instructions are internally generated.
* Other:
    * Internally changed how some tasks are scheduled with new delay API.

##### 8.2.6
* Fixed issue which occurred when all rulesets were disabled.

##### 8.2.5
* Fixed ordering issues with patron panel.
* Started internal file organization change (make sure to update addon while wow isn't running).

##### 8.2.4
* Fixed issue with color settings.

##### 8.2.3
* Bag slots:
  * Fixed bug with herb pouches in classic servers (thank you Denzer - Mirage EU).
  * Ammo pouches now colored the same as quivers.
  * Added option to color soul bags.
  * Added soul bag bottom filter.
* Character icons:
  * Now shows racial and gender based icons for offline characters instead of the current character 3D model.

##### 8.2.2
* Fixed issue introduced last version which renamed the "All" options at each category.

##### 8.2.1
* Now compatible with World of Warcraft classic servers.
  * Same version can run both on retail and classic.
  * Does not support keyring yet (don't have a character with a key).
  * Added filters specific for classic servers.
* Fixed an issue with subfilter selection.
* Added option for quiver coloring.
* Updated Ace libraries.

#### 8.2.0
* Updated for Rise of Azshara.

##### 8.1.1
* Fixed bank automatic sorting issue.

#### 8.1.0
* Updated for World of Warcraft patch 8.1.5.
* Now shows item count tooltips for singleton characters in a server
* Now handles server names differently, which should fix server specific issues
   * You might need to re-login on some characters for their data to show
* Updated French and Russian localization.
* Fixed issue with bag toggle button.
* Fixed issue with splitting item stacks in the guild bank
* Fixed issue with character specific settings
* Fixed issue preventing Void Storage from working and that could also cause minor guild bank issues
* Fixed "numbered string" internal bug

##### 8.0.2
* Fixed issue with auto display events.
* Added display event for scrapping machines.
* Added portrait icons for the remaining 4 allied races. Improved Nightborne and Goblin icons.
* Items now display the azerite and artifact alternative border artwork.
* Can now search for "azerite", "artifact" and "unusable" items. Keywords translated for the different locales.
* Redesigned color options panel.
* Fixed issue with disabling inventory or bag frames.
* Added patron list in the configuration options. See patreon.com/jaliborc to learn how to join the list.
* Fixed issue with double clicking the title bar.
* Fixed issue with Void Storage.

##### 8.0.1
* Reduced tooltip count memory usage by about 80%.
* Fixed issue with updating inventory and bank frames.
* Fixed issue with properly marking the bank frame as "live" (not cached).
* Fixed issue with Aggra server.

#### 8.0
* Updated for Battle for Azeroth
* Another major internal update! Completely reworked the internal system for representing item data.
  * The previous system, although more memory efficient, suffered from many problems. It would easily break with updates of the game. It required constant re-specification, making developing and maintaining plugins for other developers much harder.
  * More importantly, the previous system was designed before the advent of Guild Banks. These were considered a set of bags controlled by the player character, which led to a whole set of issues. In the new system, this is no longer the case.
* Visible changes:
  * Guilds are now considered independent entities from player characters.
  * Tooltip counts now display icons for each _owner_ and their portraits (characters and guilds are displayed separately).
* Bugfixes:
  * Now handles server names with spaces properly.
  * Now handles the first 4 released allied races properly.
  * Fixed issue with empty slots coloring according to bag types.
  * Fixed issue with basic rulesets considering the reagent bank a normal bag.
  * Fixed issue on realms that are not connected to other realms.
  * Fixed issue on realms with hyphens on their names that caused other characters not to be browsable.
  * Fixed multiple issues with character specific settings.
  * Reset the character specific settings that were screwed up by the previous version.
  * Fixed issue with deleting owner information.
  * The money total tooltip now displays player icons just alike the tooltip counts.
  * Fixed an issue when depositing items in the bank.
  * Fixed an issue with the _owner_ icon generator.
  * Added back _:GetItem_ API function of item buttons for legacy purposes (plugin support).

#### 7.3
* Updated for Shadow of Argus

##### 7.2.2
* Updated internal library (AceEvent) that reportedly was causing problems and preventing the program to load for users running other specific addons.

##### 7.2.1
* Tagging release

#### 7.2.0 (beta)
* Updated for WoW patch 7.2
* New item layout that mimics more closely the behaviour of pre-7.1
* New "options" slashcommand option
* Minor internal changes

##### 7.1.2 (beta)
* Complete overhaul of the configuration menus!
  - Available options are now similar to the ones available in Bagnon.
  - New frame customization options.
  - New feature toggling options.
  - New color options.
* Fixed issue with some UI elements in the bank frame.

##### 7.1.1 (beta)
* Added support for the old ruleset API, such that existing plugins still work.

#### 7.1.0 (beta)
* Major update! The large majority of Combuctor now runs on the same code as Bagnon.
  - This will allow to bring all of the features of Bagnon into Combuctor.
  - This will also make Combuctor easier to keep up to date.
  - Settings had to be reset.
  - The API for registering item rulesets has been changed. New documentation and a legacy API translator will be up soon.

#### 7.0.0
* Updated for Legion.
* Special thanks to Tuller and the community for updating the mod while I was away!

##### 6.2.1
* Fixed flash find bug

#### 6.2
* Updated for Fury of Hellfire
* Update for new library versions

#### 6.1
* Updated for patch 6.1

##### 6.0.6
* Fixed issue preventing proper stack splitting on right click.

##### 6.0.5
* Fixed issue causing window to behave strangely when clicking on the "loot won" frame.
* Fixed issues with item coloring (ex: highlight item sets not working properly).
* No longer displays warning messages when depositing non-reagents in the bank or when the reagent bank is full.
* No longer causes cursor flickering at vendors.
* The player dropdown list now displays all your connected realm characters.
  - The new class and race introduced in 6.0.10 should help to keep the list manageable for players with many characters.
  - Tooltips still only display players from the same faction (to keep tooltip sizes manageable) as only BOA accounts are sharable between these characters.
* Other minor bug fixes.

##### 6.0.4
* Now supports all the Blizzard item sorting features, such as:
  - Ignoring bags for auto sort.
  - Setting bags to a specific type of loot.
* Bags now display the number of empy slots available.
* Reagents now take priority in going to the reagent bank before other bag slots when depositing.
* Items in the bank reagents slot are now properly accounted on item tooltips.
* Changed item glow flashes:
  - Now are optional.
  - If enabled, stay for a limited period of time, but remains with a bolder glow than regular items until the bag is closed or mouse over.
* Now the player dropdown list displays class colors and race icons. This should make it much easier to find players in long lists.
* Now only characters from the same faction as yours will be displayed in the character list.
  - You must login again in your characters so that BagBrother can learn their factions!
* Fixed issue preventing right clicking on the sort button to work at all.
* More minor bugfixes.

##### 6.0.3
* Removed two developer files that caused error messages.

##### 6.0.2
* Fixed initialization issue.
* Fixed bug causing tooltips not to appear on the reagents bank slot.
* Fixed issue preventing bank slots from being purchased.
* Fixed errors with player listing.

##### 6.0.1 (beta)
* Added auto sort/deposit reagents button to all windows.
* Redesigned search bar.

##### 6.0.0 (beta)
* Updated for Warlords of Draenor

##### 5.4.0
* Updated for Siege of Ogrimmar.
* Added support for the new in-game store features.

##### 5.3.2
* Fixed error affecting some users on login.

##### 5.3.1
* Now border coloring features can be disabled at the interface options.
* Hopefully fixed issue causing item cooldowns and locked states to not be shown properly.
* Added missing french localization.

#### 5.3.0
* Updated for patch Escalation.
* Upgraded search engine, which means:
  - Smarter syntax and better search results.
  - Now items belonging to equipment sets are colored separately. Packed with ItemRack and Wardrobe support!
* Fixed bug causing error message on rare login situations.

#### 5.2.0
* Updated for patch 5.2: The Thunder King!
* Fixed an issue causing some cached items to not display any icon.
* Small code optimizations.

##### 5.1.2
* Added support for cooking bags.

##### 5.1.1
* Fixed small but annoying localization bug.

##### 5.1.0
* Updated for patch 5.1: Landfall!

##### 5.0.3
* Updated Korean localization, by 노분노씹새끼.

##### 5.0.2
* Tagging as release.

##### 5.0.1 (beta)
* Updated for compatibility with latest Scrap version.

##### 5.0.0 (beta)
* Updated and tested for Mists of Pandaria.
* Added monk class and pandaren race.
* Bug fixes.

##### 4.3.12
* Added option to display item counts on tooltips

##### 4.3.11
* Updated LibItemSearch (search engine) to latest version

##### 4.3.10
* Fixed bug causing money frame tooltip to not show on mousehover
* Redesigned money frame tooltip

##### 4.3.9
* Important hot hotfix

##### 4.3.8
* Tagging release

##### 4.3.7 (beta)
* Bugfixes

##### 4.3.6 (beta)
* Preventing code taint

##### 4.3.5 (beta)
* Hotfix

##### 4.3.4 (beta)
* Fixed a bug causing settings to not be saved between sessions.

##### 4.3.3 (beta)
* Now comes packed with BagBrother, an addon that stores bag, bank and vault data for offline viewing. This addon is shared with Bagnon.
* Added support for BagSync and Armory caching systems.

##### 4.3.2
* Fixed a bug causing the frame selector to show at unusual situations

##### 4.3.1
* Fixed bug causing BagSync support to not work properly
* Added portuguese translations

#### 4.3.0
* Jaliborc: Updated for WoW 4.3
* Jaliborc: No more "Jaliborc" tag. If there is nothing there, it means it was me.

##### 4.2.6
* Jaliborc: Tagging as release

##### 4.2.5
* Jaliborc: The config has been divided into two windows - "General" & "Sets"
* Jaliborc: New options at the "General" window - "Display Sets on Left" and "Act as Interface Panel"
* Jaliborc: Estetical improvements to the "Sets" window
* Jaliborc: Removed unecessary code

##### 4.2.4
* Jaliborc: The windows can no longer be dragged of the screen.

##### 4.2.3
* Jaliborc: Tagging as release version

##### 4.2.2
* Jaliborc: Fixed bug causing errors when opening the options menu

##### 4.2.1
* Jaliborc: Added unusable item coloring
* Jaliborc: Improved the quality filter design
* Jaliborc: Remade the windows so that they tile when resizing instead of stretching
* Jaliborc: Fixed a bug with the heirloom color
* Jaliborc: Fixed a bug when clicking the money box

#### 4.2.0
* Updated for WoW 4.2.0
* Tinkered a bit more with fixing frame positions to work properly when managed/unmanaged
* Removed keyring bits.

##### 4.1.2
* Reworked the quality filter again to make it a bit more similar to the old style.
* Selecting no qualities on the quality filter will now show all items.
* Selecting a quality will now show items of that quality only.
* Modifier clicking a quality will add the quality to the selection.

##### 4.1.tuba
* Added a fix for the issue people were having where the bank frame was not updating. Hopefully it works :)
* Fixed a bug causing empty item slots to not properly update in color when swapping bags of different types.
* Revamped the quality filter
* Clicking a quality button will now toggle showing that quality. Empty slots are shown regardless of quality selected.
* Modifier clicking an unchecked quality filter will select only that quality.
* Added heirlooms to the quality filter.
* The legendary filter also now includes artifacts.

##### 2.4.3
* Fixed LibItemSearch reference in the TOC file to make it load on demand properly

##### 2.4.2
* Localization bugfixes

##### 2.4.1
* Fixed a bug preventing Combuctor from showing up when you visit a bank.

#### 2.4.0
* Updated TOCs for 4.1
* Added a fix for the frame not remembering position issue
* Did a lot of restructuring, which probably will result in some bugs

##### 2.3.2
* Tackle box fix (thanks JuddMan)
* Compatibility fixes for WoW 4.1

##### 2.3.1
* Bugfix

#### 2.3.0
* 4.0.6 fixes (this version won't work with pre 4.0.6 versions)
* Added tacle box support (for reals this time?)

##### 2.2.5
* Added BagSync support.
* Removed Bagnon_Forever from the main download. (It'll still work, though)
* Added tackle box support (I hope :P)
* Updated LibItemSearch, you can now perform tooltip searches via tt:<search>

##### 2.2.4b
* Added back missing Bagnon_Forever + Bagnon_Tooltips folders

##### 2.2.4
* Fixed some compatibility issues with v4.0.1: specifically the player selector not working.

##### 2.2.3b
* Added back the Bagnon_Forever + Bagnon_Tooltips folders

##### 2.2.3
* Updated for WoW v4.0.1

##### 2.2.2
* Fixed a typo causing an error when moving an item onto an empty part of the Combuctor frame.

##### 2.2.1
* Fixed a bug causing the bank frame to not display
* Fixed an error when picking up a bag

#### 2.2.0
* Pushed in some changes I made in Bagnon.  This should hopefully fix the bank frame issue.
* Added in quest item highlighting
* Added in empty slot coloring based on bag type

##### 2.1.4
* Removed debug prints from the bank frame

##### 2.1.3
* Updated for 3.3
* Updated LibItemSearch, adding in support for equipment sets (s:setname), item level (ilvl:level), and comparison operators (ex, q<=epic)

##### 2.1.2
* Updated for 3.2
* Added currency tracking to the money frame tooltip, thanks to Nyghtingale

##### 2.1.1
* Bagnon_Forever fixes

#### 2.1.0
* Heavily revised text searches
* Pure text searches now only look at item names.
* t:<text> searches look at item type/subtype/equiploc information
* q:<text> searches look at quality information (ex, q:0 or q:epic)
* boe, bop, boa, bou, and quest perform tooltip searches for bind on x and quest item information.
* It is possible to negate a search (ex, !q:epic)
* It is possible to perform an intersection search (ex, q:epic&t:weapon for all epic weapons)
* It is possible to perform an union search (ex, t:weapon|t:armor for all items that are either armor or weapons).

##### 2.0.8
* Bumped TOC for 3.1
* Added left side tabs (no GUI so far for it)

##### 2.0.7
* Updated Russian localization

##### 2.0.6
* Fixed some localization bugs

##### 2.0.5
* Updated translations
* Fixed a minor tooltip issue

##### 2.0.4
* Updated Chinese translation
* Turns out I was using my old wrath branch for Bagnon_Forever + Bagnon_Tooltips

##### 2.0.3-Repackage
* Made Bagnon_Forever not LOD

##### 2.0.3
* Fixed a bug caused by missing localization files.

##### 2.0.2
* Fixed a bug with version updating

##### 2.0.1
* Fixed a bug with Bagnon_Forever

#### 2.0.0
* A wrath compatible rewrite.
* Added the ability to resize the frame via dragging the bottom right corner
* Added the ability to customize which categories are displayed on the frames (/combuctor)
* Added the ability for developers to add in more sets and subsets to Combuctor
* Combuctor is still very much a beta at this point in time: The new features are very much a first draft.
