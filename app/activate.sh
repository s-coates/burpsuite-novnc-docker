#!/usr/bin/expect

set HOME "/home/burp"

# set the licence
set license "add_your_licence_here"

# remove user prefs
spawn rm -f $HOME/.java/.userPrefs/burp/prefs.xml

expect eof

# start burpsuite
spawn java -Djava.awt.headless=true -jar $HOME/burpsuite_pro.jar

expect "*Do you accept the license agreement*?" { send -- "y\r" }
expect "*paste your license key below*" { send -- "$license\r" }
expect "*Enter preferred activation method*" { send -- "o\r" }

# expect an eof otherwise this causes things to hang
expect eof