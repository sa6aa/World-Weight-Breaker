
#!/bin/bash

echo "[FAJIR BUILDER] إعداد بيئة البناء..."

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools/30.0.3
export PATH=$PATH:/opt/gradle-8.13/bin

echo "[✓] جميع المسارات مفعلة"

echo "[FAJIR] بناء التطبيق..."
cd "$(dirname "$0")"
gradle assembleDebug

echo "[✓] تم بناء APK:"
find . -name "*.apk"
