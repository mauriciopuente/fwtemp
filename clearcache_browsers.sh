exec 1>>/var/log/fwcld.log

exec 2>>/var/log/fwcld.log


# Kill ALL Browsers if they are running ...

firefox=$(ps -xa | grep -i "firefox.app" | grep -v grep | awk {'print $1'})
chromeinstances=$(ps -xa |grep -i "Google Chrome.app/Contents/MacOS/Google Chrome" | grep -v grep | awk {'print $1'})
safari=$(ps -xa | grep -i "Safari.app" | grep -v grep | awk {'print $1'})

kill -9 $firefox
kill -9 $chromeinstances
kill -9 $safari



temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

for i in $temp

do

echo "UserName --> ${i} : "

if [ -d "/Users/${i}/Library/Application Support/Google/Chrome" ]; then

	echo "removing the google chrome directory ..."

	rm -rf "/Users/${i}/Library/Application Support/Google/Chrome"

else

	echo "Chrome Directory doesn't exist. Nothing to do."

fi


if [ -d "/Users/${i}/Library/Application Support/Firefox" ]; then

        echo "removing the Firefox directory ..."

        rm -rf "/Users/${i}/Library/Application Support/Firefox"

else

        echo "Firefox Directory doesn't exist. Nothing to do."

fi



if [ -d "/Users/${i}/Library/Safari" ]; then

        echo "removing the Safari directory ..."

        rm -rf "/Users/${i}/Library/Safari"

	rm -rf "/Users/${i}/Library/Caches/com.apple.Safari"

	rm -rf "/Users/${i}/Library/Cookies"

	rm -rf "/Users/${i}/Library/Preferences/com.apple.Safari*"

	rm -rf "/Users/${i}/Library/Preferences/com.apple.WebKit.WebContent.plist"

	rm -rf "/Users/${i}/Library/PubSub/Database"

	rm -rf "/Users/${i}/Library/Saved Application State/com.apple.Safari.savedState"
else

        echo "Safari Directory doesn't exist. Nothing to do."

fi



done
