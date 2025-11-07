# 🚀 ChilliGuard - Quick Start Guide

## ⚡ Run This Now

### 1️⃣ Start Backend (Terminal 1)

```bash
cd "D:\DOWNLOADS\KJ SOMAIYA\SEM 7\FINAL YEAR Project\Perplexity Made\chilliguard\backend"
python run.py
```

### 2️⃣ Start Frontend (Terminal 2)

```bash
cd "D:\DOWNLOADS\KJ SOMAIYA\SEM 7\FINAL YEAR Project\Perplexity Made\chilliguard\mobile_app"
flutter clean
flutter pub get
flutter run
```

### 3️⃣ Test in App

1. Open app on your phone
2. Tap **floating camera button** (center bottom)
3. Tap **"Gallery"**
4. Select any image
5. Tap **"Detect"**
6. See results! 🎉

---

## ✅ What Should Happen

### Backend Terminal:

```
Starting ChilliGuard Backend Server...
Server running on http://localhost:5000
✅ Firebase initialized
✅ API routes registered
```

### When You Detect:

```
2025-11-02 21:30:00 - INFO - 🔄 Disease detection request received
2025-11-02 21:30:00 - INFO - Image loaded: 123456 bytes
2025-11-02 21:30:01 - INFO - ✅ Detection successful: Bacterial Spot
```

### Flutter Logs:

```
I/flutter: 📤 Uploading image to: http://192.168.0.100:5000/api/v1/disease/detect
I/flutter: ✅ Detection successful: {disease_name: Bacterial Spot, ...}
```

### App Screen:

- ✅ Disease name displayed
- ✅ Severity badge (colored)
- ✅ Confidence percentage
- ✅ Symptoms list
- ✅ Treatment recommendations

---

## 🚨 If Something Goes Wrong

### "Connection Refused"

```bash
# Check PC IP
ipconfig
# Update mobile_app/lib/core/constants/app_constants.dart if needed
```

### "Backend Not Running"

```bash
# Make sure you see this:
Server running on http://localhost:5000
```

### "Old Camera Screen Shows"

```bash
# Clean rebuild
flutter clean
flutter pub get
flutter run
```

---

## 📋 Changed Files Summary

✅ `app_constants.dart` - Fixed base URL
✅ `simple_disease_screen.dart` - Fixed endpoint URL
✅ `dashboard_screen.dart` - Navigation to new screen
✅ `batch_detail_screen.dart` - Navigation to new screen
✅ `AndroidManifest.xml` - Added permissions

**Backend:** No changes needed ✅

---

## 📚 Full Documentation

- **Testing Guide:** See `TEST_CONNECTIVITY.md`
- **Complete Changes:** See `CHANGES_SUMMARY.md`

---

**Ready? Run the commands above! 🚀**
