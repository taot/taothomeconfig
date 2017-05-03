if [ -z $ANDROID_HOME ]; then
    echo 'No Android SD found.'
    echo 'Please set $ANDROID_HOME to your Android SDK (e.g. ~/Android/Sdk)'
    exit -1
fi

echo "Available emulators:"
echo
${ANDROID_HOME}/tools/emulator -list-avds
echo
last_emulator=$(cat ~/.start-android-emulator-last)
echo -n "Emulator to run [$last_emulator]: "
read emulator
if [ -z $emulator ]; then
    emulator=$last_emulator
else
    echo $emulator > ~/.start-android-emulator-last
fi
${ANDROID_HOME}/tools/emulator -use-system-libs -avd "${emulator}"
