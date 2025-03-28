
#!/bin/bash

echo "[FAJIR REBUILDER] جاري تنفيذ إعادة بناء FAJIR.apk..."

# التأكد من وجود الأدوات
if ! command -v apktool &> /dev/null; then
    echo "[!] apktool غير مثبت! يرجى تثبيته: apt install apktool"
    exit 1
fi

if ! command -v zipalign &> /dev/null; then
    echo "[!] zipalign غير مثبت! يرجى تثبيته: apt install zipalign"
    exit 1
fi

if ! command -v apksigner &> /dev/null; then
    echo "[!] apksigner غير مثبت! يرجى تثبيته: apt install apksigner"
    exit 1
fi

# اسم المشروع والمسارات
PROJECT_DIR=$(pwd)
OUT_DIR="$PROJECT_DIR/output"
APK_UNSIGNED="$OUT_DIR/fajir-unsigned.apk"
APK_SIGNED="$OUT_DIR/FAJIR.apk"

# تجهيز مجلد الإخراج
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# إعادة ترجمة التطبيق
apktool b "$PROJECT_DIR" -o "$APK_UNSIGNED"

# توليد keystore إذا ما كان موجود
if [ ! -f "$OUT_DIR/fajir-keystore.jks" ]; then
    keytool -genkey -v -keystore "$OUT_DIR/fajir-keystore.jks" -keyalg RSA -digestalg SHA-384 -sigalg SHA384withRSA -storepass الخورزاميه -keypass الخورزاميه -alias fajir -dname "CN=Abdulaziz, OU=CyberAI, O=FAJIR, L=Internet, C=SA" -validity 10000
fi

# توقيع APK
zipalign -v 4 "$APK_UNSIGNED" "$APK_SIGNED"
apksigner sign --ks "$OUT_DIR/fajir-keystore.jks" --ks-key-alias fajir --ks-pass pass:الخورزاميه --key-pass pass:الخورزاميه "$APK_SIGNED"

echo "[✓] تم توقيع التطبيق بنجاح:"
echo "$APK_SIGNED"
