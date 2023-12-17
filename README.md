# PiMe

A Vanilla / Classic WoW Addon to manage Power Infusion requests (For Mages, Locks, Priests)

# Is this Addon for me?

This addon is for ...
* 1.12.1 World of Warcraft clients, and
* **for [Priests](#Using-PiMe-as-a-Priest)** with Power Infusion and
* **for [Mages/Warlocks](#Using-PiMe-as-a-Mage-or-Warlock)** that would want it.

**If you're a Priest**, have a Mage/Warlock whisper you "PI ME" and PiMe'll alert you or auto-whisper the remaining cooldown.

**If you're a Mage / Warlock**, PiMe alerts you when you receive Power Infusion and starts a 3 minute timer to let you know when it's off cooldown.

# Using PiMe as a Priest

## Functionality

* If someone whispers you with "**pi me**" this addon tries to get you to notice. It will...

    1) play an annoying sound,
    2) show an annoyingly large power infusion icon on screen, and
    3) print a big annoying text banner in your chat window

    (each of which can be turned off).

* If someone whispers you with "**pi check**" this addon whispers back to tell them when it'll be up next.

## FWIW...

* you don't need to know/care who asked,
* the mage/warlock doesn't need to be on 1.12 nor does he have to have PiMe installed, and
* you MAY work with a "buddy" and you both benefit a little if you do (see below)

![Priest view](/images/PiMe_Priests.png?raw=true)

## Example usage for Priests

As a priest, you'll only have the giant power infusion icon to worry about. 

### Getting Set Up

* Type **`/pime unlock`** to see and move the giant power infusion icon, then
* type **`/pime lock`** to hide it again.
* Set yourself as your PI buddy **`/pime buddy [yourname-or-target-yourself]`** then manually whisper yourself with "**`/w [yourname] pi me`**".
* You will see a giant icon, text, and a sound will play. Type **`/pime settings`** to learn how to turn off any you dislike.

### Testing with a Mage or Warlock (even if they don't have PiMe)

* Set the mage/warlock as your PI target with **`/pime buddy Magenamehere`**.
* Have them whisper you with the text "**`PI CHECK`**". 
        PiMe will reply to say that Power Infusion is *available now*.
* Have them whisper you with "**`PI ME`**".
        You'll see alerts. 
        Use **`/pime settings`** to turn off any you dislike.
* Cast Power Infusion or use **`/pime cast`**.
* Have buddy whisper you again with **`PI CHECK`** and **`PI CAST`**.
        PiMe will let them know it's on cooldown.

That's it!

# Using PiMe as a Mage or Warlock

## Sales pitch

This addon will notice when Power Infusion is cast upon you and then start a 3 minute countdown to let you know it's next available.

## Functionality

* When you gain the PI buff it will..

    * Play a sound,
    * show a large icon,
    * print a text banner in your chat window,
    * update a cooldown timer bar, and
    * print a chat message once the timer is up
    
    (each of which can be turned off).

* You can configure a buddy and use a macro to demand PI (`/pime cast`) or to see ask for the cooldown time (`/pime check`).

## FWIW...

* You don't need to know/care who cast it upon you.
* The priest doesn't need to be on 1.12 nor does he have to have PiMe installed.
* If you DO know/care you can set up a "buddy" (`/pime buddy Bestpriestever`) to request it.

![Mage view On Cast](/images/PiMe_Mages_OnCast.png?raw=true)

![Mage view After Cooldown](/images/PiMe_Mages_AfterCooldown.png?raw=true)

## Example usage for Mages and Warlocks

First, let's move that cooldown timer bar. 

### Getting Set Up

* Type **`/pime unlock`** and move the timer bar and power infusion icon.
* Type **`/pime lock`** to hide the icon and re-lock the timer bar.
* Set your Priest with **`/pime buddy [priestname-or-target]`**.

### Testing with a Priest (even if they don't have PiMe)

* Type **`/pime check`** and see it whisper your buddy.
         A Priest with PiMe will reply with the cooldown and won't cast it.
* Type **`/pime cast`** and see it whisper your buddy.
        A Priest with PiMe will reply with the cooldown or his UI will pester him to cast PI.
* When you gain Power Infusion, PiMe will show alerts. Use **`/pime settings`** to turn off those you dislike.
* You know PI is on cooldown, but verify with **`/pime check`** again to see it in action.

That's it!

# Installation

* Download the zip
* Extract the zip into your `World of Warcraft/Interface/Addons` directory
* Remove the `-master` suffix from the directory name
* Log in, type `/pime help`

# Other addons like PiMe
* [ChroniclesPI](https://github.com/EinBaum/ChroniclesPI) - Looks like it does the equivalent of PiMe's "/pime cast" call.
* [EmeraldPowerInfusion](https://github.com/NyxxisTW/EmeraldPowerInfusion/) - This addon shows the power infusion icon. I actually added this functionality to PiMe after seeing it in this addon but still wanted my whisper functionality. Thanks Nyxxis!
* [HBPowerInfusion](https://github.com/hitbutton/HBPowerInfusion) - I haven't used this addon but it looks like it plays a sound and handles whispers. Looks like it's set up for several different buffs, too.
* [PIBuddy](https://github.com/rljohn/pibuddy) - This addon is for retail. It looks cooler than my addon, and I liked the idea of one addon that handled both perspectives of watching the Power Infusion cooldown, so I added the "buddy" concept after seeing this addon. Thanks, rljohn!
* [PowerInfusionHandler](https://github.com/kevmodrome/PowerInfusionHandler) - Looks like it's for mages. Plays a sound and shows a nice "candy bar" cooldown bar when you gain PI.
* If you're on 1.14 client, look into WeakAuras.

Feel free to check these other addons out. There's no way PiMe is uniquely valuable, it's just so hard to find a Vanilla addon that tells you what it is, what it's for, and how it's used so I ended up making my own. Hope it helps someone.

FWIW I've tried to make PiMe have a tiny memory footprint. It doesn't use extra code libraries, it doesn't use custom sounds, it intentionally only updates the UI only 5 seconds so to keep memory utilization as TINY as possible. **This addon is two steps above a couple handy macros and that's a plus if you're anti-addon.**

# Special thanks

* My PI "Buddies" Nagma and Ribbons. Thanks for bein' awesome. Thanks to Ribbons for alpha testing this addon.
* To Maegi who sent me his button code from his "EternalDarkness" addon.
* Thanks to `<Pest Control>` and `<threat>` on Everlook for a really fun 2023-4.
* Thanks to `<Fists of Niall>` and `<Blue Mountain>` on Arthas for a really fun 2005-6.

