# PiMe

A Vanilla / Classic WoW Addon to manage Power Infusion requests (For Mages, Locks, Priests)

# Is this Addon for me?

This addon is for 1.12.1 World of Warcraft clients, and for Priests with Power Infusion or for Mages/Locks (*scroll down for the mage/lock sales pitch*) that would want it.

# Priests 

## Sales pitch
As a priest you will often forget to cast PI on your raid's Mage/Lock. Or, if you do, they're often low mana, afk / not ready, the mob is magic-resistant, etc. This addon moves the burdeon a bit by getting the mage/lock to request it from you. (NOTE - It does not *automatically* cast PI, you still have to cast it yourself, either "normally" or with `/pime cast`).

## Functionality

* If someone whispers you with "**pi me**" this addon tries to get you to notice. It will...

    1) play an annoying sound,
    2) show an annoyingly large power infusion icon on screen, and
    3) print a big annoying text banner in your chat window

    (each of which can be turned off).

* If someone whispers you with "**pi check**" this addon auto-replies to tell them if/when it'll be up.  

## FWIW...

* you don't need to know/care who asked,
* the mage/lock doesn't need to be on 1.12 nor does he have to have PiMe installed, and
* you MAY work with a "buddy" and you both benefit a little if you do (see below)

# Mages / Locks

## Sales pitch

This addon will notice when Power Infusion is cast upon you and then start a 3 minute countdown to let you know it's available.

## Functionality

* When you gain the PI buff it will..

    1) show a small indicator bar that shows you how much time is left until it's available again,
    2) print the message "Power Fusion is available!" once the timer is up,
    3) play an annoying sound,
    4) show an annoyingly large power infusion icon on screen, and
    5) print a big annoying text banner in your chat window
    
    (each of which can be turned off).

* You can configure a buddy and then you can use a macro to ask for PI (`/pime cast`) or to see what the cooldown is (`/pime check`).

## FWIW...

* You don't need to know/care who cast it upon you.
* The priest doesn't need to be on 1.12 nor does he have to have PiMe installed.
* If you DO know/care you can set up a "buddy" (`/pime buddy Bestpriestever`) to request it.

# Installation

* Download the zip
* Extract the zip into your `World of Warcraft/Interface/Addons` directory
* Remove the `-master` suffix from the directory name
* Log in, type `/pime help`

# Special thanks

* "EmeraldPowerInfusion" Addon - I added this guy's "show the icon" concept to PiMe. Thanks Nyxxis! Check his addon out here: https://github.com/NyxxisTW/EmeraldPowerInfusion/
* "PIBuddy" Addon - I added the wording of "buddy" from seeing this addon's existence. It's a Retail WoW addon so I didn't look at it closely, but I'm sure it's amazing. Check it out if you're on Retail WoW. https://github.com/rljohn/pibuddy
* My PI "Buddies" Nagma and Ribbons. Thanks for bein' awesome. Thanks to Ribbons for helping me vet this addon.
* Thanks to `<Pest Control>` and `<threat>` on Everlook for a really fun 2023.
* Thanks to `<Fists of Niall>` and `<Blue Mountain>` on Arthas for a really fun 2005-6.
