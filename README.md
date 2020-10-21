# Toothly - Flutter App for managing the appointments of a stomatology clinic 
Bachelor Degree Project

## Requirements

[√] [**Flutter (Channel beta)**](https://flutter.dev/docs/get-started/install)

  * Flutter version 1.23.0-18.1.pre 
  * Dart version 2.11.0 (build 2.11.0-213.1.beta)
  
[√] [**Android Studio (>= version 3.5)**](https://developer.android.com/studio)

  * Flutter plugin version 44.0.1
  * Dart plugin version 191.8593
  * Java version OpenJDK Runtime Environment (build 1.8.0_202-release-1483-b03)
  
[√] Android toolchain - develop for Android devices **(Android SDK version 29.0.2)**

  * Platform **android-29**, build-tools **29.0.2**
  * Java version OpenJDK Runtime Environment (build 1.8.0_202-release-1483-b03)
  * All Android licenses accepted.

## Setup

 ### __Flutter__
 
   After installing flutter from the link provided above, add the __flutter/bin__ folder __path__ to the __environment variables table__ (Restart is recommended). Open a command prompt and check if the **flutter** command works properly. 
     
  _List of useful commands for flutter:_
  
  * **flutter doctor:** show information about the installed tooling;
  * **flutter upgrade:** upgrade your copy of flutter;
  * **flutter create [app name]:** create a new flutter project;
  * **flutter build:** build the executable app;
  * **flutter clean:** delete the build/ and .dart-tool/ directories;
  * **flutter install:** install a flutter app on an attached device;
  * **flutter run:** running a flutter app on the attached device;
  * **flutter pub get:** get the flutter packages in a flutter project;
  * **flutter pub update:** update the flutter packages in a flutter project; 
     
     
     
 ### __Android Studio for Flutter projects__
   
   When you open Android Studio for the first time you shall see in the down right corner the button **Configure**, clicking on it shows you an options' list. What we need to check from those are:
   
   - **AVD Manager** - create a new emulator on which you'll be able to run the app;
   
      - Select ***Create Virtual Device***
      - You can choose the blueprint that suits you the most. (Choosing the latest stable SDK version of Android is recommended)
      
      *another way of creating an emulator is being already in a project and selecting ***Android Studio>Tools>AVD Manager***
   
   - **SDK Manager** - manage the SDK versions;
   
      - ***SDK Manager>SDK Tools*** check the box for the ***Google USB Driver*** in order to install it;
   
   - **Plugins** 
   
      - install Flutter plugin;
      - install Dart plugin;
      
   (!) *If you have problems with seeing the emulator in the devices list, you might have to check the ANDROID_HOME in the environment variables table and give the right path to it.*
   
 ### __Firebase__
   
   In order to link the database to the flutter app:
   
   - Go [**here**](https://firebase.google.com) and create a free account;
   - Click on **Go to console** button (top right);
   - **Add project**, name the project [Toothly] and press the **Create project** button;
   - Add app by clicking the android icon;
   - To find the Android package name you go to **android/app/build.gradle** and you'll gonna see it in the **defaultConfig>applicationId** as ***"com.licenta.toothly"***;
   - (optional) give a nickname to the app;
   - Click **Register app**;
   - Download config file and put the file in **android/app** folder;
   
  Console part:
  
  - In **Authentication>Sign-in method** enable Email/Password and Google;
  - In **Cloud Firestore** make the following [**db collections schema**](https://github.com/maramih/toothly/blob/master/collections.png);
  
  Cloud functions setup:
  
  - TBD
  
  
