# PiMe

A Vanilla / Classic WoW Addon to manage Power Infusion requests (For Mages, Locks, Priests)

# Is this Addon for me?

This addon is for 1.12.1 World of Warcraft clients, and for <b>Priests</b> with Power Infusion or for <b>Mages/Locks</b> (*scroll down for the mage/warlock sales pitch*) that would want it.

# Installing PiMe for Priests 

## Sales pitch
As a priest you will often forget to cast PI on your raid's Mage/Lock. Or, if you do, they're often low mana, afk / not ready, the mob is magic-resistant, etc. This addon moves the burdeon a bit by getting the mage/warlock to request it from you. (NOTE - It does not *automatically* cast PI, you still have to cast it yourself, either "normally" or with `/pime cast`).

## Functionality

* If someone whispers you with "**pi me**" this addon tries to get you to notice. It will...

    1) play an annoying sound,
    2) show an annoyingly large power infusion icon on screen, and
    3) print a big annoying text banner in your chat window

    (each of which can be turned off).

* If someone whispers you with "**pi check**" this addon auto-replies to tell them if/when it'll be up.  

## FWIW...

* you don't need to know/care who asked,
* the mage/warlock doesn't need to be on 1.12 nor does he have to have PiMe installed, and
* you MAY work with a "buddy" and you both benefit a little if you do (see below)

![Priest view](/images/PiMe_Priests.png?raw=true)

## Example usage for Priests

As a priest, you'll only have the giant power infusion icon to worry about. 

### Getting Set Up
<ul>
    <li>First, type <b><tt>/pime unlock</tt></b> to see the giant power infusion icon and move it to your preferred spot. 
        Do this when you're not in a boss fight so it doesn't surprise you in a bad way. :^)
    </li>
    <li>Next, type <b><tt>/pime lock</tt></b> to hide it again.</li>
    <li>Next, test it on yourself by setting yourself as the PI buddy <b><tt>/pime buddy [yourname-or-target-yourself]</tt></b> then manually whisper yourself with "<b><tt>/w [yourname] pi me</tt></b>". 
        You should see a giant annoying icon, a pile of annoying chat text, and an annoying sound should play.
    </li>
    <li>Type <b><tt>/pime settings</tt></b> to learn how to turn off the icon/text/sound.</li>
</ul>

### Testing with a Mage or Warlock (even if they don't have PiMe)

<ul>
    <li>Set them as your PI target with <b><tt>/pime buddy <i>Bestmagenameever</i></tt></b>.</li>
    <li>Have them whisper you with the text "<b><tt>PI CHECK</tt></b>". 
        You will automatically whisper in reply to say that Power Infusion is <i>available now</i> or what the remaining cooldown is.
    </li>
    <li>Have them whisper you with "<b><tt>PI ME</tt></b>". 
        Use <b><tt>/pime settings</tt></b> to turn off alerts you don't like.
    </li>
    <li>Cast Power Infusion or use <b><tt>/pime cast</tt></b>.</li>
    <li>Have buddy whisper you again with <b><tt>PI CHECK</tt></b> and <b><tt>PI CAST</tt></b>.
        Since it's on cooldown both will behave the same - whispering in reply.
    </li>
</ul>

That's it!

# Installing PiMe for Mages / Locks

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

![Mage view On Cast](/images/PiMe_Mages_OnCast.png?raw=true)

![Mage view After Cooldown](/images/PiMe_Mages_AfterCooldown.png?raw=true)

## Example usage for Mages and Warlocks

As a recipient of Power Infusion, when you log in you'll have this <b>big annoying PiMe bar</b> in the middle of your screen and no way to move it without reading the documentation! :^)

### Getting Set Up
<ul>
    <li>Type <b><tt>/pime unlock</tt></b> and move the timer bar movable power infusion icon.</li>
    <li>Type <b><tt>/pime lock</tt></b> to hide the icon and re-lock the timer bar.</li>
    <li>Set your Priest with <b><tt>/pime buddy [priestname-or-target]</tt></b></li>
</ul>

### Testing with a Priest (even if they don't have PiMe)

<ul>
    <li>Type <b><tt>/pime check</tt></b> and see it whisper your buddy. 
        If they have PiMe, they'll auto-reply with the cooldown and won't think they should cast it.
    </li>
    <li>Type <b><tt>/pime cast</tt></b> and see it whisper your buddy. 
        If they have PiMe, they'll auto-reply with the cooldown if it's not available, otherwise they'll be prompted to cast PI on you.
    </li>
    <li>When you gain Power Infusion as a buff PiMe will show a giant annoying icon, print a bunch of annoying text, play an annoying sound, and start a visual countdown.</li>
    <li>Type <b><tt>/pime settings</tt></b> to learn how to turn off the icon/text/sound.</li>
    <li>You know PI is on cooldown, but verify with <b><tt>/pime check</tt></b> again.
    </li>
</ul>

That's it!


# Installation

* Download the zip
* Extract the zip into your `World of Warcraft/Interface/Addons` directory
* Remove the `-master` suffix from the directory name
* Log in, type `/pime help`

# Other addons like PiMe
<ul>
<li>[ChroniclesPI](https://github.com/EinBaum/ChroniclesPI) - Looks like it does the equivalent of PiMe's "/pime cast" call.</li>
<li>[EmeraldPowerInfusion](https://github.com/NyxxisTW/EmeraldPowerInfusion/) - This addon shows the power infusion icon. I added this functionality to PiMe after seeing it in this addon but still wanted my whisper functionality.</li>
<li>[HBPowerInfusion](https://github.com/hitbutton/HBPowerInfusion) - I haven't used this addon but it looks like it plays a sound and handles whispers. Looks like it's set up for several different buffs, too.
<li>[PIBuddy](https://github.com/rljohn/pibuddy) - This addon is for retail. It looks cooler than my addon, and I liked the idea of one addon that handled both perspectives of watching the Power Infusion cooldown, so I added the wording of "buddy" from seeing this addon.</li>
<li>[PowerInfusionHandler](https://github.com/kevmodrome/PowerInfusionHandler) - Looks like it's for mages. Plays a sound and shows a nice "candy bar" cooldown bar when you gain PI.
<li>If you're on 1.14 client, look into WeakAuras.</li>
</li>

Feel free to check these other addons out. Honestly I think there's no way PiMe is uniquely valuable, it's just so hard to find a Vanilla addon that tells you what it is, what it's for, and how it's used!

FWIW I've tried to make PiMe have a tiny memory footprint. It doesn't use extra code libraries, it doesn't use custom sounds, it intentionally only updates the UI only 5 seconds so to keep memory utilization as TINY as possible. <b>This addon is two steps above a couple handy macros and that's a plus if you're anti-addon.</b>

# Special thanks

* My PI "Buddies" Nagma and Ribbons. Thanks for bein' awesome. Thanks to Ribbons for alpha testing this addon.
* To Maegi who sent me his button code from his "EternalDarkness" addon.
* Thanks to `<Pest Control>` and `<threat>` on Everlook for a really fun 2023-4.
* Thanks to `<Fists of Niall>` and `<Blue Mountain>` on Arthas for a really fun 2005-6.

