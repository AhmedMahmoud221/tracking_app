import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @darkmode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkmode;

  /// No description provided for @totaldevices.
  ///
  /// In en, this message translates to:
  /// **'Total Devices'**
  String get totaldevices;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @moving.
  ///
  /// In en, this message translates to:
  /// **'Moving'**
  String get moving;

  /// No description provided for @lasttrackeddevice.
  ///
  /// In en, this message translates to:
  /// **'Last Tracked Device'**
  String get lasttrackeddevice;

  /// No description provided for @tracknow.
  ///
  /// In en, this message translates to:
  /// **'Track Now'**
  String get tracknow;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @recentactivities.
  ///
  /// In en, this message translates to:
  /// **'Recent Activities'**
  String get recentactivities;

  /// No description provided for @alldevices.
  ///
  /// In en, this message translates to:
  /// **'All Devices'**
  String get alldevices;

  /// No description provided for @adddevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get adddevice;

  /// No description provided for @nodevicesfound.
  ///
  /// In en, this message translates to:
  /// **'No Devices Found'**
  String get nodevicesfound;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @lastlocation.
  ///
  /// In en, this message translates to:
  /// **'Last Location'**
  String get lastlocation;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @idling.
  ///
  /// In en, this message translates to:
  /// **'Idling'**
  String get idling;

  /// No description provided for @towed.
  ///
  /// In en, this message translates to:
  /// **'Towed'**
  String get towed;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @devicedetails.
  ///
  /// In en, this message translates to:
  /// **'Device Details'**
  String get devicedetails;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @platenumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get platenumber;

  /// No description provided for @searchdevices.
  ///
  /// In en, this message translates to:
  /// **'Search Devices'**
  String get searchdevices;

  /// No description provided for @createdevice.
  ///
  /// In en, this message translates to:
  /// **'Create Device'**
  String get createdevice;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get motorcycle;

  /// No description provided for @truck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get truck;

  /// No description provided for @startedmoving.
  ///
  /// In en, this message translates to:
  /// **'Started moving'**
  String get startedmoving;

  /// No description provided for @gpsupdated.
  ///
  /// In en, this message translates to:
  /// **'GPS updated'**
  String get gpsupdated;

  /// No description provided for @wentoffline.
  ///
  /// In en, this message translates to:
  /// **'Went offline'**
  String get wentoffline;

  /// No description provided for @mintago.
  ///
  /// In en, this message translates to:
  /// **'mint ago'**
  String get mintago;

  /// No description provided for @oldpassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldpassword;

  /// No description provided for @newpassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newpassword;

  /// No description provided for @confirmpassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmpassword;

  /// No description provided for @passwordsdonotmatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsdonotmatch;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editprofile;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editdevice.
  ///
  /// In en, this message translates to:
  /// **'Edit Device'**
  String get editdevice;

  /// No description provided for @devicecreatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Device Created Successfully'**
  String get devicecreatedsuccessfully;

  /// No description provided for @deviceupdatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Device Updated Successfully'**
  String get deviceupdatedsuccessfully;

  /// No description provided for @adddeviceamage.
  ///
  /// In en, this message translates to:
  /// **'Add Device Image'**
  String get adddeviceamage;

  /// No description provided for @areyousureyouwanttodeletethisdevice.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this device?'**
  String get areyousureyouwanttodeletethisdevice;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enteryouremail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enteryouremail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enteryourpassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enteryourpassword;

  /// No description provided for @youdonthaveanaccount.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have an account?'**
  String get youdonthaveanaccount;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @forgetpassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetpassword;

  /// No description provided for @forgetpasswordappbar.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetpasswordappbar;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signin;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enteryourusername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enteryourusername;

  /// No description provided for @alreadyhaveanaccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyhaveanaccount;

  /// No description provided for @resetyourpassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetyourpassword;

  /// No description provided for @pleasefillallfields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleasefillallfields;

  /// No description provided for @emailrequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailrequired;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @nochats.
  ///
  /// In en, this message translates to:
  /// **'No chats yet.'**
  String get nochats;

  /// No description provided for @privatechat.
  ///
  /// In en, this message translates to:
  /// **'Private Chat'**
  String get privatechat;

  /// No description provided for @chatwith.
  ///
  /// In en, this message translates to:
  /// **'Chat with a single person'**
  String get chatwith;

  /// No description provided for @groupchat.
  ///
  /// In en, this message translates to:
  /// **'Group Chat'**
  String get groupchat;

  /// No description provided for @creategroup.
  ///
  /// In en, this message translates to:
  /// **'Create a group with multiple people'**
  String get creategroup;

  /// No description provided for @typemessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get typemessage;

  /// No description provided for @vedio.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get vedio;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Decument'**
  String get document;

  /// No description provided for @slidetocancel.
  ///
  /// In en, this message translates to:
  /// **'Slide to cancel'**
  String get slidetocancel;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout, check your internet.'**
  String get connectionTimeout;

  /// No description provided for @sendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Failed to send data, please try again.'**
  String get sendTimeout;

  /// No description provided for @receiveTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server did not respond in time.'**
  String get receiveTimeout;

  /// No description provided for @processCancelled.
  ///
  /// In en, this message translates to:
  /// **'Process was cancelled.'**
  String get processCancelled;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get noInternet;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, an unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later.'**
  String get genericError;

  /// No description provided for @badRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid data.'**
  String get badRequest;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access.'**
  String get unauthorized;

  /// No description provided for @forbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have access permission.'**
  String get forbidden;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Page or user not found.'**
  String get notFound;

  /// No description provided for @internalServerError.
  ///
  /// In en, this message translates to:
  /// **'Internal server error, we are working on it.'**
  String get internalServerError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @tryagain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryagain;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
