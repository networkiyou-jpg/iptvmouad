# Mouad IPTV Player — Enigma2

مشغل IPTV لأجهزة Enigma2 (OpenATV وغيرها): روابط M3U، ملفات M3U، حسابات Xtream Codes، قنوات مباشرة مع EPG، أفلام، مسلسلات، إعادة، مفضلة، بحث، أربع شاشات.

## التثبيت (Telnet / SSH)

انسخ هذا السطر في Telnet أو SSH على الجهاز:

```
wget -q --no-check-certificate https://raw.githubusercontent.com/networkiyou-jpg/iptvmouad/main/installer.sh -O - | /bin/sh
```

الجهاز يعيد تشغيل الواجهة تلقائياً بعد التثبيت. البلوجين في: **Menu ← Plugins ← Mouad IPTV Player**.

- التحديث: نفس الأمر. الاشتراكات والمفضلة والإعدادات والترخيص لا تُحذف.
- الإزالة:
  ```
  wget -q --no-check-certificate https://raw.githubusercontent.com/networkiyou-jpg/iptvmouad/main/uninstall.sh -O - | /bin/sh
  ```

## الترخيص

- **تجربة مجانية 7 أيام** تبدأ تلقائياً عند أول فتح (الجهاز يجب أن يكون متصلاً بالإنترنت).
- للتفعيل الدائم: افتح البلوجين ← زر **MENU** ← **الترخيص والتفعيل**، وأرسل **Device ID** أو **MAC** (أو صورة رمز QR) إلى البائع، ثم أدخل كود التفعيل واضغط **تفعيل**.

## الدعم

Telegram: **@Kingsharing1**
