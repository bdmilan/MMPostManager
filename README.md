# MM Post Manager

Java + SQLite Android app. Package: `com.example.mmpostmanager`.

## Features
- Create, edit and trash posts; restore or permanently delete from Trash.
- Create, rename and delete categories. Posts are retained as Uncategorized if a category is deleted.
- Live text search and category filter.
- JSON backup/restore using Android's Storage Access Framework.
- Optional automatic backup every 24 hours to the selected backup document URI using WorkManager.

## Build on Windows
1. Install Android Studio (includes Android SDK) and JDK 17.
2. Open this folder in Android Studio and allow Gradle sync. Install Android SDK Platform 35 if prompted.
3. The included `gradlew.bat` bootstraps Gradle 8.7 into your user Gradle cache on first run (requires internet and PowerShell).
   `gradlew.bat assembleDebug`
5. APK output:
   `app\build\outputs\apk\debug\app-debug.apk`

If the first-run download is blocked, install Gradle 8.7 manually and add it to PATH, then run `gradle assembleDebug`.

## Google Drive backup and OAuth notes
Backup/Restore is implemented through Android's Storage Access Framework (SAF), not a direct Google Drive REST/OAuth client. When you tap **Backup to Drive**, Android's document picker appears; choose Google Drive (and sign in to the Drive app if asked), then save the JSON file in Drive. The app retains the selected document URI and WorkManager overwrites that same document every 24 hours. Choose a Drive-backed document URI for cloud automatic backups. If Google Drive is not shown, install/update the Google Drive Android app and sign in.

This SAF approach intentionally avoids embedding OAuth client secrets in an APK. No Google Cloud OAuth client ID is required for the included implementation. For a future direct Drive API integration: create/select a Google Cloud project, enable Google Drive API, configure the OAuth consent screen, create an Android OAuth client using the app package `com.example.mmpostmanager` and your signing certificate SHA-1, add the Google Identity/Drive scopes required by the Drive API, and implement token acquisition plus Drive `files.create`/`files.update`. Never ship a client secret in the Android app. The current app does not request Google Drive OAuth scopes directly; Drive account authorization is handled by the Drive document provider.

## Backup format
A UTF-8 JSON document containing categories and posts. Restore replaces the current categories and posts. Export a backup before restoring if you need to keep the current data.

## Notes
- Database is local SQLite (`mm_posts.db`).
- Automatic backup runs approximately every 24 hours (Android WorkManager periodic work is not an exact clock-time scheduler); the first run may be delayed by Android battery/network policies.
- This project is a functional starter implementation. Test backup/restore with a small dataset before relying on it for important content.


## Build APK using only an Android phone (GitHub Actions)
This project includes `.github/workflows/android-build.yml`.

1. On your Android phone, open https://github.com/ and sign in (create a free account if needed).
2. Create a new repository, for example `MMPostManager`. A public or private repository works.
3. In the repository, use **Add file → Upload files** in the browser. Extract `MMPostManager.zip` first if needed, then upload the project contents, including the hidden `.github/workflows/android-build.yml` folder/file. If the mobile browser cannot upload hidden folders, create `.github/workflows/android-build.yml` in GitHub using **Add file → Create new file** and paste the workflow content from the project.
4. Commit the files to `main`.
5. Open the repository's **Actions** tab. Select **Android APK Build** and tap **Run workflow** (or wait for the automatic run after a push).
6. Open the completed green workflow run. Under **Artifacts**, download `MMPostManager-debug-apk`.
7. Extract the downloaded artifact ZIP. It contains `app-debug.apk`. Open it on your phone and allow installation from that source if Android asks.

The cloud workflow uses Ubuntu, JDK 17, Android SDK and Gradle 8.7. No PC, Android Studio, Termux, or local Gradle installation is needed on the phone. GitHub's interface labels may vary slightly on mobile. Do not upload signing keys, passwords, OAuth client secrets, or other private credentials to the repository.
