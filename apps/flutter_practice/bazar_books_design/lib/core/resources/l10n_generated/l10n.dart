// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class BazUiS {
  BazUiS();

  static BazUiS? _current;

  static BazUiS get current {
    assert(_current != null,
        'No instance of BazUiS was loaded. Try to initialize the BazUiS delegate before accessing BazUiS.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<BazUiS> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = BazUiS();
      BazUiS._current = instance;

      return instance;
    });
  }

  static BazUiS of(BuildContext context) {
    final instance = BazUiS.maybeOf(context);
    assert(instance != null,
        'No instance of BazUiS present in the widget tree. Did you add BazUiS.delegate in localizationsDelegates?');
    return instance!;
  }

  static BazUiS? maybeOf(BuildContext context) {
    return Localizations.of<BazUiS>(context, BazUiS);
  }

  /// `There was a temporary problem launch email system. Please try again later.`
  String get errorEmailClient {
    return Intl.message(
      'There was a temporary problem launch email system. Please try again later.',
      name: 'errorEmailClient',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back 👋`
  String get signInPageWelcomeBack {
    return Intl.message(
      'Welcome Back 👋',
      name: 'signInPageWelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get signInPageLogin {
    return Intl.message(
      'Login',
      name: 'signInPageLogin',
      desc: '',
      args: [],
    );
  }

  /// `Sign to your account`
  String get signInPageYourAccount {
    return Intl.message(
      'Sign to your account',
      name: 'signInPageYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get signInPageEmail {
    return Intl.message(
      'Email',
      name: 'signInPageEmail',
      desc: '',
      args: [],
    );
  }

  /// `No Email`
  String get noEmailTitle {
    return Intl.message(
      'No Email',
      name: 'noEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your email`
  String get signInPageYourEmail {
    return Intl.message(
      'Your email',
      name: 'signInPageYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get signInPagePassword {
    return Intl.message(
      'Password',
      name: 'signInPagePassword',
      desc: '',
      args: [],
    );
  }

  /// `Your password`
  String get signInPageYourPassword {
    return Intl.message(
      'Your password',
      name: 'signInPageYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get signInPageForgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'signInPageForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Or with`
  String get signInPageOrWith {
    return Intl.message(
      'Or with',
      name: 'signInPageOrWith',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInPageWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInPageWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get signInPageWithApple {
    return Intl.message(
      'Sign in with Apple',
      name: 'signInPageWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account?`
  String get signInPageDontHaveAnAccount {
    return Intl.message(
      'Don’t have an account?',
      name: 'signInPageDontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signInPageSignUp {
    return Intl.message(
      'Sign Up',
      name: 'signInPageSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Top of Week`
  String get homePageTopOfWeek {
    return Intl.message(
      'Top of Week',
      name: 'homePageTopOfWeek',
      desc: '',
      args: [],
    );
  }

  /// `Best Vendors`
  String get homePageBestVendors {
    return Intl.message(
      'Best Vendors',
      name: 'homePageBestVendors',
      desc: '',
      args: [],
    );
  }

  /// `Authors`
  String get authorsTtile {
    return Intl.message(
      'Authors',
      name: 'authorsTtile',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get generalLoading {
    return Intl.message(
      'Loading...',
      name: 'generalLoading',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get generalSeeAll {
    return Intl.message(
      'See all',
      name: 'generalSeeAll',
      desc: '',
      args: [],
    );
  }

  /// `Product is empty`
  String get homePageProductEmpty {
    return Intl.message(
      'Product is empty',
      name: 'homePageProductEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get generalRefresh {
    return Intl.message(
      'Refresh',
      name: 'generalRefresh',
      desc: '',
      args: [],
    );
  }

  /// `success`
  String get generalSuccess {
    return Intl.message(
      'success',
      name: 'generalSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection.`
  String get errorNoInternetConnection {
    return Intl.message(
      'Please check your internet connection.',
      name: 'errorNoInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Success with no data (no content).`
  String get errorNoContent {
    return Intl.message(
      'Success with no data (no content).',
      name: 'errorNoContent',
      desc: '',
      args: [],
    );
  }

  /// `Failure, API rejected request`
  String get errorBadRequest {
    return Intl.message(
      'Failure, API rejected request',
      name: 'errorBadRequest',
      desc: '',
      args: [],
    );
  }

  /// `Failure, user is not authorised`
  String get errorUnauthorized {
    return Intl.message(
      'Failure, user is not authorised',
      name: 'errorUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Failure, user is not authorised`
  String get errorForbidden {
    return Intl.message(
      'Failure, user is not authorised',
      name: 'errorForbidden',
      desc: '',
      args: [],
    );
  }

  /// `Not found error`
  String get errorNotFound {
    return Intl.message(
      'Not found error',
      name: 'errorNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Conflict error`
  String get errorConflict {
    return Intl.message(
      'Conflict error',
      name: 'errorConflict',
      desc: '',
      args: [],
    );
  }

  /// `Internal Server error`
  String get errorInternalServer {
    return Intl.message(
      'Internal Server error',
      name: 'errorInternalServer',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get errorUnknown {
    return Intl.message(
      'Unknown error',
      name: 'errorUnknown',
      desc: '',
      args: [],
    );
  }

  /// `Timeout error`
  String get errorTimeout {
    return Intl.message(
      'Timeout error',
      name: 'errorTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Recieve error`
  String get errorRecieve {
    return Intl.message(
      'Recieve error',
      name: 'errorRecieve',
      desc: '',
      args: [],
    );
  }

  /// `Default error`
  String get errorDefault {
    return Intl.message(
      'Default error',
      name: 'errorDefault',
      desc: '',
      args: [],
    );
  }

  /// `No name`
  String get noName {
    return Intl.message(
      'No name',
      name: 'noName',
      desc: '',
      args: [],
    );
  }

  /// `No Phone Number`
  String get noPhone {
    return Intl.message(
      'No Phone Number',
      name: 'noPhone',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logoutTitle {
    return Intl.message(
      'Logout',
      name: 'logoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelTitle {
    return Intl.message(
      'Cancel',
      name: 'cancelTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout?`
  String get logoutMeassage {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutMeassage',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get addressTtile {
    return Intl.message(
      'Address',
      name: 'addressTtile',
      desc: '',
      args: [],
    );
  }

  /// `Offers & Promos`
  String get offersAndPromosTtile {
    return Intl.message(
      'Offers & Promos',
      name: 'offersAndPromosTtile',
      desc: '',
      args: [],
    );
  }

  /// `Your Favorites`
  String get yourFavoritesTtile {
    return Intl.message(
      'Your Favorites',
      name: 'yourFavoritesTtile',
      desc: '',
      args: [],
    );
  }

  /// `Order History`
  String get orderHistoryTtile {
    return Intl.message(
      'Order History',
      name: 'orderHistoryTtile',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get helpCenterTtile {
    return Intl.message(
      'Help Center',
      name: 'helpCenterTtile',
      desc: '',
      args: [],
    );
  }

  /// `Change Picture`
  String get changePictureTtile {
    return Intl.message(
      'Change Picture',
      name: 'changePictureTtile',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChangesTtile {
    return Intl.message(
      'Save Changes',
      name: 'saveChangesTtile',
      desc: '',
      args: [],
    );
  }

  /// `Email already exists, please check again!`
  String get errorConflictEmail {
    return Intl.message(
      'Email already exists, please check again!',
      name: 'errorConflictEmail',
      desc: '',
      args: [],
    );
  }

  /// `Cache error`
  String get errorCache {
    return Intl.message(
      'Cache error',
      name: 'errorCache',
      desc: '',
      args: [],
    );
  }

  /// `Send timeout in connection with API server`
  String get errorSendTimeout {
    return Intl.message(
      'Send timeout in connection with API server',
      name: 'errorSendTimeout',
      desc: '',
      args: [],
    );
  }

  /// `No content available`
  String get generalListEmpty {
    return Intl.message(
      'No content available',
      name: 'generalListEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get generalTitleHome {
    return Intl.message(
      'Home',
      name: 'generalTitleHome',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get generalTitleName {
    return Intl.message(
      'Name',
      name: 'generalTitleName',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get generalTitleCategory {
    return Intl.message(
      'Category',
      name: 'generalTitleCategory',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get generalTitleCart {
    return Intl.message(
      'Cart',
      name: 'generalTitleCart',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get generalTitleSearch {
    return Intl.message(
      'Search',
      name: 'generalTitleSearch',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get generalTitleMyAccount {
    return Intl.message(
      'My Account',
      name: 'generalTitleMyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Recent Searches`
  String get titleRecentSearches {
    return Intl.message(
      'Recent Searches',
      name: 'titleRecentSearches',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get generalTitleProfile {
    return Intl.message(
      'Profile',
      name: 'generalTitleProfile',
      desc: '',
      args: [],
    );
  }

  /// `No results found.`
  String get foundNoResults {
    return Intl.message(
      'No results found.',
      name: 'foundNoResults',
      desc: '',
      args: [],
    );
  }

  /// `Start searching for products.`
  String get startSearching {
    return Intl.message(
      'Start searching for products.',
      name: 'startSearching',
      desc: '',
      args: [],
    );
  }

  /// `Order Now`
  String get orderNow {
    return Intl.message(
      'Order Now',
      name: 'orderNow',
      desc: '',
      args: [],
    );
  }

  /// `Special Offer`
  String get specialOffer {
    return Intl.message(
      'Special Offer',
      name: 'specialOffer',
      desc: '',
      args: [],
    );
  }

  /// `Continue shopping`
  String get continueButton {
    return Intl.message(
      'Continue shopping',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `View cart`
  String get viewButton {
    return Intl.message(
      'View cart',
      name: 'viewButton',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get reviewTitle {
    return Intl.message(
      'Review',
      name: 'reviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra dignissim ac ac ac.`
  String get detailMenuDescription {
    return Intl.message(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra dignissim ac ac ac.',
      name: 'detailMenuDescription',
      desc: '',
      args: [],
    );
  }

  /// `GoodDay`
  String get detailMenuGoodDayTitle {
    return Intl.message(
      'GoodDay',
      name: 'detailMenuGoodDayTitle',
      desc: '',
      args: [],
    );
  }

  /// `Vendors`
  String get vendorTitle {
    return Intl.message(
      'Vendors',
      name: 'vendorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Our Vendors`
  String get vendorSubtitle {
    return Intl.message(
      'Our Vendors',
      name: 'vendorSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Check the authors`
  String get authorSubtitle {
    return Intl.message(
      'Check the authors',
      name: 'authorSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get productTitle {
    return Intl.message(
      'Products',
      name: 'productTitle',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get aboutTitle {
    return Intl.message(
      'About',
      name: 'aboutTitle',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allTabBar {
    return Intl.message(
      'All',
      name: 'allTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Poets`
  String get poetsTabBar {
    return Intl.message(
      'Poets',
      name: 'poetsTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Playwrights`
  String get playwrightsTabBar {
    return Intl.message(
      'Playwrights',
      name: 'playwrightsTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Novelists`
  String get novelistsTabBar {
    return Intl.message(
      'Novelists',
      name: 'novelistsTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Journalists`
  String get journalistsTabBar {
    return Intl.message(
      'Journalists',
      name: 'journalistsTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Stationery`
  String get stationeryTabBar {
    return Intl.message(
      'Stationery',
      name: 'stationeryTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get booksTabBar {
    return Intl.message(
      'Books',
      name: 'booksTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Poems`
  String get poemsTabBar {
    return Intl.message(
      'Poems',
      name: 'poemsTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Special for you`
  String get specialForYouTabBar {
    return Intl.message(
      'Special for you',
      name: 'specialForYouTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password.`
  String get authenticationFailure {
    return Intl.message(
      'Invalid email or password.',
      name: 'authenticationFailure',
      desc: '',
      args: [],
    );
  }

  /// `Page Not Found`
  String get errorRoute {
    return Intl.message(
      'Page Not Found',
      name: 'errorRoute',
      desc: '',
      args: [],
    );
  }

  /// `Novels`
  String get novelsTabBar {
    return Intl.message(
      'Novels',
      name: 'novelsTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Self Love`
  String get selfLoveTabBar {
    return Intl.message(
      'Self Love',
      name: 'selfLoveTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Science`
  String get scienceTabBar {
    return Intl.message(
      'Science',
      name: 'scienceTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Romantic`
  String get romanticTabBar {
    return Intl.message(
      'Romantic',
      name: 'romanticTabBar',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 8 characters`
  String get hasMinLength {
    return Intl.message(
      'Minimum 8 characters',
      name: 'hasMinLength',
      desc: '',
      args: [],
    );
  }

  /// `At least 1 number (1-9)`
  String get hasNumber {
    return Intl.message(
      'At least 1 number (1-9)',
      name: 'hasNumber',
      desc: '',
      args: [],
    );
  }

  /// `At least lowercase or uppercase letter`
  String get hasLetter {
    return Intl.message(
      'At least lowercase or uppercase letter',
      name: 'hasLetter',
      desc: '',
      args: [],
    );
  }

  /// `View Profile Picture`
  String get viewProfilePicture {
    return Intl.message(
      'View Profile Picture',
      name: 'viewProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Capture New Photo`
  String get captureNewPhoto {
    return Intl.message(
      'Capture New Photo',
      name: 'captureNewPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Select From Gallery`
  String get selectFromGallery {
    return Intl.message(
      'Select From Gallery',
      name: 'selectFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `No Profile Picture Available`
  String get noProfilePictureAvailable {
    return Intl.message(
      'No Profile Picture Available',
      name: 'noProfilePictureAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No photo captured.`
  String get noPhotoCaptured {
    return Intl.message(
      'No photo captured.',
      name: 'noPhotoCaptured',
      desc: '',
      args: [],
    );
  }

  /// `Photo captured and avatar updated.`
  String get updatePhotoAndAvatar {
    return Intl.message(
      'Photo captured and avatar updated.',
      name: 'updatePhotoAndAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Camera permission permanently denied. Please enable it from settings.`
  String get deniedCameraPermission {
    return Intl.message(
      'Camera permission permanently denied. Please enable it from settings.',
      name: 'deniedCameraPermission',
      desc: '',
      args: [],
    );
  }

  /// `Open App Settings`
  String get openAppSettings {
    return Intl.message(
      'Open App Settings',
      name: 'openAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `Permission denied!`
  String get deniedPermission {
    return Intl.message(
      'Permission denied!',
      name: 'deniedPermission',
      desc: '',
      args: [],
    );
  }

  /// `Avatar updated successfully!`
  String get updatedAvatarSuccessfully {
    return Intl.message(
      'Avatar updated successfully!',
      name: 'updatedAvatarSuccessfully',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<BazUiS> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<BazUiS> load(Locale locale) => BazUiS.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
