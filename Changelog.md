### 12.1.1
* __New Feature:__ Added option to reverse order of item stacks in sorting options (co-authored by _lucienve_).
* Redesigned sorting options on retail, to make it clearer which settings are only available when using client sorting. 
* Overall localization update (co-authored by _lucienve_).

## 12.1
* __Retail:__ Now compatibile with 12.1 servers. Opening banks might be less efficient, because Blizzard screwed the pooch.
* Improved german localization (by _opatut_).

### 12.0.19
* __Hotfix:__ Fixed file loading mistake on retail servers introduced in the last build.

### 12.0.18
* __Improvement:__  Updated addon list formatting for Classic realms.
* __Bugfixes:__ 
  * Fixed blank gray Blizzard backpack button when inventory frame is disabled (by _lucienve_).
  * Fixed Blizzard backpack missing item slots when inventory frame is disabled.
  * Fixed specific instances of right-click item usage blocking related to banking (by _lucienve_).
  * Resolved error message thcd "C:\Users\Jaliborc\Files\Work\Addons\upmod"
  * node cli at could occur when addon Pawn is installed (by _lucienve_).
  * Fixed wrong offline currency count for some warband currencies (by _lucienve_).

### 12.0.17
* Improved memory management on offline viewing guild and void storage banking (by _lucienve_).
* Updated TOC for Classic realms.

### 12.0.16
* Fixed sorting ordering bug that could occur with reverse-sorting enabled.
* Updated TOC for Burning Crusade.

### 12.0.15
* Improved Bagnonium sorting algorithm (co-authored by _lucienve_):
  * Now prevents sending duplicate requests and server-side transaction drops/failures (which can rate-limit operations).
  * Identical items are now matched to minimize the number of swaps required to sort.
  * You can now stop an active sort by clicking the sort button again (especially helpful for long processes like the guild bank).

### 12.0.14
* Removed all use of the now unsecure blizzard "MoneyFrame" templates.
* Reversed minor change which accidentally disabled item counts in TBC.

### 12.0.13
* Now forces the deprecated `Twilight's Blade Insignia` to not be tracked, which is impossible to manually untrack.
* __Bagnonium Exclusive:__ Now users can set up keybindings for opening the bank and guild bank from anywhere.

### 12.0.12
* Updated for WoW patch 12.0.7.
* Updated TOC for Mists.
* Items you send to another of your characters are now immediately be counted on item tooltips (co-authored by _Dramacydal_).
* Removed all references to `SetTooltipMoney`, a problematic Blizzard function that has since been deprecated.
* Added workaround to unexplained Blizzard issue where the Offline View menu would appear large and with a scrollbar even when unecessary.

### 12.0.11
* Now should display icons for Erathen and Haranir characters correctly.
* Updated the content of the Help menu, as some information was becoming outdated and could cause confusion amongst players.
* Added fix that prevents Blizzard causing secret taint when displaying money on tooltips.

### 12.0.10
* Updated TOC numbers.
* Added check to make sure money is properly sorted for unitialized characters (by _gmlew77t_).

### 12.0.9
* Added mechanism to prevent tooltip issue that could appear in unkown circumstances. Apologies for the inconvenience.

### 12.0.8
* Hotfix typo in previous build.

### 12.0.7
* __Bug Fix:__ Added workarounds to issues created by Blizzard secret value spread on tooltips.
* __Improvement:__ Characters on account gold tooltip now appear sorted by highest gold amount _(by dfherr)_.

### 12.0.6
* __Bagnonium Exclusive:__
  * Item grid now reacts to the currency list becoming multi-line, and no longer overlaps with it.
* __Hotfix:__ Currency tracking now works as intended on both retail and classic servers.

### 12.0.5
* Fixed issue caused by Blizzard changes that prevented more than 3 currencies from being tracked at a time.

### 12.0.4
* __Guild Bank:__
  * Fixed issue starting the guild bank introduced last version.
  * Now large tab permission numbers are formatted for easier reading (example: 1000 becomes 1k)

### 12.0.3
* Fixed issue in settings upgrade system which was causing warband bank data to be reset on login.
* Fixed error message on startup that would appear to players that have disabled the Bagnon inventory.
* Added falllback mechanism to prevent issues in case user somehow disables all side filters in a frame.
* Fixed situation in which players could disable all side filters.

### 12.0.2
* Created icons for Shift-Left-Click and Shift-Right-Click actions that are now used on tooltips.
* Fixed potential theoretical issue with nil item searches.

## 12.0.1
* Community contributions!
  * Equipment sets are now automatically registered as search filters.  You can also Shift-Click them to equip (co-authored by _r15ch13_)
  * Improved frame positioning logic to account for offset UIParent (by _Aerothal_).

## 12.0.0
After 25 versions of "early-release", I'm happy to say that I am now confident with the state of the addon and it matches my vision for it. Here are the changes for this release.
* __Server Support:__
  * Added support for Burning Crusade Anniversary realms.
  * Updated TOC numbers for live Midnight realms.
* __Bag Disabling Improvements:__
  * The main menu buttons now correctly reflect which bags are enabled in the inventory frame.
  * Bagnon will no longer disable the "combined bags" setting if the inventory frame is disabled.
  * Retail - fixed issue displaying blizzard bags through the "Fallback" setting. 
* __Tooltip Item Counts:__
  * New Feature: Now tracks items in the mailbox and includes them in tooltip item counts!
  * Bug Fix: Fixed issue that caused equipped items to be incorrectly shown to be in the bags in tooltip item counts.
* __Other Changes:__
  * Shift-Right Clicking an item now inverts where it is stored - if you have player tab selected, deposits on the warband and vice-versa.
  * If you have characters with duplicated names, now the corresponding server names will be shown.

### 0.25
* __Bagnonium Exclusive:__
  * Created two new skins, _Smooth_ and _Speckled_, which are now used by default on the Bank and Guild Bank frames on retail servers.
* __Improved Performance:__
  * Opening a window for the first time each session is now **29% faster**.
  * Massively improved search engine performance by developing a JIT compiler - search and filters are now **13.51 times faster**! That's a **1351% improvement**!
* __Tooltips:__
  * Tooltip currency counts now correctly update during gameplay.
  * To increase readability, money tooltip now hides copper amounts when dealing with large amounts of gold.
  * To increase readability, large numbers in tooltip currency counts are now formatted as in the rest of the UI.
* __Other Improvements:__
  * You can now search battle pets by name, both online and offline.
  * The sort options menu now detects and refreshes when the blizzard settings change (these client settings can take time to change, and it was visually confusing to use).
  * Updated dropdown buttons in Bagnon Options to use the new native implementation. Their appearance will now match the version of the game.
* __Bug Fixes:__
  * Fixed the missing "Opening the World Map" button text in auto-display options.
  * Fixed issue that caused custom search filters to not always exactly match a normal text search, for example when using a keyword like _Soulbound_ or _Warbound_.
  * Fixed error message that could appear when searching offline characters.
  * Made workaround to stop bug being caused by a major flaw with CallbackHandler-1.0.
  * Overall reduced reliance on CallbackHandler-1.0 wherever possible.

### 0.24
* __Improved Warbank Interaction:__
  * Using an item from your bags while viewing the Warband Bank tab will now deposit it directly into the Warband Bank.
  * Added a new protocol API (`Addon_Get/SetBankType`) so addons (e.g., TSM) can detect which bank interface (Player or Warband) is currently active.
* __Bug Fix:__ Resolved an issue that could cause the rule edit frame to display in an incorrect screen position. _(Thanks to r15ch13)_

### 0.23
* **Mists:** Visual bugfix.

### 0.22
* **Sorting Options:**
  * Added option to invert looting order in the sort options menu.
  * Added unique sound design to the item locking mode.
* **Minor Change:** The default number of displayed characters is now 10 (to match how it worked before multi-realm viewing was possible on Retail).
* **Retail, Bagnonium Exclusive:** Changed default slot background.

### 0.21
* Added support for Midnight open beta.

### 0.20
* Minor improvement to StaleCheck-1.0.

### 0.19
* Minor optization of ruleset code.
* Ensured the default tab will always be "All", until the user selects one for the first time, to avoid confusing existing users.

### 0.18
* Fixed a bug introduced last version preventing item refreshes.

### 0.17
* **New Feature:** Selected filters are now remembered between sessions.
* Retail: Updated TOC to 12.2.5.

### 0.16
* All: Modified BagBrother's item storage format, prioritizing future-proofing it for Blizzard changes on retail.
  * This fixes the recent issues with keystone tooltips.
  * Removed some unecessary data introduced recently by Blizzard.
* Retail: The deposit button toggle button now appears in the settings as intended once again.
* All: Improved the efficiency of tooltip count generation.

### 0.15
* All: Fixed texture rendering issues that could appear when tracking a large amount of currencies or having a lot of money.
* Retail: Right-click behaviour at the bank is no longer changed if the bank frame is disabled.
* Retail: Fixed layout positioning issues introduced by the last patch.
* Mists: Updated TOC number.

### 0.14
* All: Client-sorting can now sort in reverse!
  * Added option for reverse sorting, both for client-sorting and server-sorting (Blizzard hid this option for no clear reason).
* Fixed issues reported with the new taint-free frame display system:
  * Mists, Retail: Adressed issue that caused the default blizzard code to lag in specific game interactions.
  * Classic: The default blizzard bags now scale with the UI scaling setting appropriately.

### 0.13
* Entirely retooled Bagnonium's internal frame display logic, which required an update since the Dragonflight UI rework. You might some notice some differences:
  * The system now runs entirely-taint free, potentially making "Action Blocked" errors less likely to occur.
  * The display events settings now apply to a broader range of NPCs (ex: disabling display at the bank will also disable it at the warbound bank chest).
  * Fixed issues with disabling display events (ex: inability to not show the inventory at the mailbox if the user choses), which could not be fixed in the old system.
* Retail: Shift-right click will now fallback to a normal right click when warband bank is not available.
* Classic: Hotfixed error message introduced last version.
* Classic: Improved calculation of keyring size.

### 0.12
* Retail: Fixed error message that would appear on startup, introduced by last build (ups).
* All: Added slash command which can be used to reset the addon settings and clear the cache.

### 0.11
* Classic: Fixed error that would appear when unlocking the keyring on a character for the first time.

### 0.10
* All: Now uses the first available filter on login when the "All" tab is disabled.
* Retail: Bank deposit button now appears and behaves as expected again.
* Retail: Bank server-side sorting now behaves as expected again.
* Retail: Money is once again showed correctly within each frame.

### 0.9
* Retail: Now gracefully handles Blizzard having deleted a font from the game.

### 0.8
* Classic, Mists: fixed issue with right-clicking items introduced in the last update.

### 0.7
* Retail: Updated for patch 11.2.
* Retail: You can once again buy bank bag slots within the addon, without being blocked by the game.
* Mists: Color settings for bag types such as inscription or jewelcrafting are now available.
* Classic: Added prebuilt filters for ammo bags, soul bags and the keyring.

### 0.6
* Moved back to a full addon-based event handling, as Blizzard's event registry is prone to event loss (thank you to the dev community for all the suggestions).

### 0.5
* The filters editor help button now directs to a new instructional video (https://youtu.be/sie39ZW8uZo).
* Hotfixed an issue in blizzard's event code.

### 0.4
* Fixed issue with item pre-click logic on Mists servers.
* Fixed issue in the guild bank causing the latest messages in the log to be hidden.
* Bagnon Config now loads apropriately in Mists of Pandaria servers.
* The guild bank logs are now scrollable.

### 0.3
* Now supports Mists of Pandaria servers.
  * PLease do not submit bugs related to void storage. The blizzard beta servers are acting very weird on the storage, addons or not.
* Updated chinese localization.
* Fixed bug in character favoriting system.

### 0.2
* Tagging release.
* Fixed bug preventing startup of the databroker plugin.
* Guilds are now also stacked into a scrollable submenu when too many are listed.

### 0.1 (beta)
* Fixed bug preventing custom search filters from filtering.
* Characters from the current server group are now sorted before others by default.
* Offline view menu rework:
  * You can now favorite characters. Favorited characters take priority over all others.
  * If too many characters are present, additional characters will be shown in a scrollable overflow menu.
  * Design now adapts to each server type.
* Money tooltip now only shows the top 8 characters, and truncates the remainder into a single entry.
* The filters menu now becomes scrollable if many filters are available.
* No longer warns of detected new version on login if the user as since updated.
* Now defaults pet rarity to common in offline view if rarity is missing (to prevent bugs).

## 0 (beta)
* Initial pre-release.
* Custom artwork by Blackmane, Jaliborc and Maxime Playoust.
* Some planned features are missing, including:
  * Some basic built-in filters that were present in Combuctor.
  * Void storage support.