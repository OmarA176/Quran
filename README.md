# Quran Reels n8n Workflow (Telegram -> YouTube/TikTok)

الملف ده فيه Workflow جاهز لـ n8n ينفذ الفكرة اللي طلبتها:
1) يختار آية عشوائية + صوتها.
2) يجيب صورة طبيعية عشوائية.
3) يعمل مونتاج تلقائي (نص الآية على الفيديو + تحسينات صوت وصورة).
4) يبعت الفيديو على Telegram أولًا.
5) بعد كده يرفعه على YouTube و TikTok.

## الملفات
- `workflows/n8n_quran_reels_workflow.json`: ملف الـ workflow للاستيراد في n8n.
- `scripts/generate_quran_reel.sh`: سكربت المونتاج باستخدام ffmpeg.
- `scripts/upload_youtube.sh`: رفع الفيديو على YouTube Data API v3.
- `scripts/upload_tiktok.sh`: بدء نشر الفيديو على TikTok Content Posting API.
- `.env.example`: المتغيرات المطلوبة.

## المتطلبات
- n8n (self-hosted)
- ffmpeg + ffprobe متسطبين على نفس جهاز n8n
- مفاتيح API:
  - Telegram Bot Token + Chat ID
  - YouTube OAuth Access Token (`youtube.upload` scope)
  - TikTok Access Token

## التركيب
1. انسخ ملفات المشروع على نفس السيرفر اللي شغال عليه n8n.
2. انسخ `.env.example` إلى `.env` واملأ القيم.
3. من n8n: `Import from file` واختر:
   - `workflows/n8n_quran_reels_workflow.json`
4. فعل الـ workflow.

## تخصيصات مقترحة
- بدل مصدر الصور:
  - حاليًا: `https://picsum.photos/1080/1920`
  - ممكن Unsplash/Pexels API بسهولة من Node `Prepare Random Inputs`.
- لو عايز تستخدم [Quran-Reels-Generator](https://github.com/Arabianaischool/Quran-Reels-Generator.git) بدل ffmpeg script:
  - عدّل Node `Render Reel Video` لينفذ أمر الأداة مباشرة.
- لو عايز تأكيد يدوي قبل النشر:
  - أضف `Wait` + Telegram callback step قبل Nodes الرفع.

## ملاحظات مهمة
- **لا تضع التوكنات داخل workflow JSON**. خليك دائمًا على Environment Variables.
- TikTok endpoint المستخدم حاليًا يعتمد `PULL_FROM_URL`؛ لو هترفع ملف مباشر عدّل سكربت `upload_tiktok.sh` حسب نوع الوصول المتاح في حسابك.
- YouTube upload script مبني على resumable upload flow.

