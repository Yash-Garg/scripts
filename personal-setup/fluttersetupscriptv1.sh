#!/bin/bash
echo
echo "###########################################################################"
echo "Setting up this system for development."
echo "Flutter, Android SDK, VScode Plugin"

cd "$HOME"
PATH_CHANGES=""
touch ~/.zsh_profile

#VS Code Setup
echo
echo "======================================================="
echo "Setting up VS Code by adding it to the apt sources list"
echo "See https://code.visualstudio.com/docs/setup/linux"
echo
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get -y install apt-transport-https
sudo apt-get update
sudo apt-get -y install code # or code-insiders


code --install-extension dart-code.flutter --force
code --install-extension akhail.save-typing --force



# Flutter
echo
echo "=========================================================================="
echo "Setting up Flutter from GitHub (master)"
echo "See https://flutter.dev/docs/development/tools/sdk/releases for more info."
echo

git clone -b master https://github.com/flutter/flutter.git
./flutter/bin/flutter --version

sudo apt-get -y install lib32stdc++6

PATH="$PATH:$HOME/flutter/bin:$HOME/flutter/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin"
PATH_CHANGES+='$HOME/flutter/bin:$HOME/flutter/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin'


# Android SDK and tools
echo
echo "=========================================================="
echo "Setting up the Android SDK (without Android Studio) 4333796"
echo "See https://flutter.dev/docs/get-started/install/chromeos"
echo "and https://developer.android.com/studio/#downloads"
echo

sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk

mkdir android && cd $_
export ANDROID_HOME="$HOME/android"
echo 'export ANDROID_HOME="$HOME/android"' >> "$HOME/.zsh_profile"

wget 'https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip'
unzip sdk-tools-linux*
rm "sdk-tools-linux-4333796.zip"



PATH="$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/tools"
PATH_CHANGES+=':$ANDROID_HOME/tools/bin:$ANDROID_HOME/tools'

# Squelches a repeated warning
touch "$HOME/.android/repositories.cfg"

yes | sdkmanager --licenses
sdkmanager "build-tools;29.0.0" "emulator" "tools" "platform-tools" "platforms;android-29" "extras;google;google_play_services" "extras;google;webdriver" "system-images;android-29;google_apis_playstore;x86_64"

PATH="$PATH:$ANDROID_HOME/platform-tools"
PATH_CHANGES+=':$ANDROID_HOME/platform-tools'

cd ..

# Finishing up
echo "PATH=\"$PATH_CHANGES:\$PATH\"" >> "$HOME/.zsh_profile"
echo 'alias la="ls -a"' >> "$HOME/.zsh_profile"
echo 'alias ll="ls -la"' >> "$HOME/.zsh_profile"

flutter doctor

echo
echo "Setup complete, restart your terminal session or source ~/.profile."