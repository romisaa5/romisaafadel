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
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Romisaa Fadel'**
  String get appTitle;

  /// Full display name
  ///
  /// In en, this message translates to:
  /// **'Romisaa Fadel'**
  String get displayName;

  /// Professional title
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer · Mobile Application Development'**
  String get professionalTitle;

  /// Splash loading message
  ///
  /// In en, this message translates to:
  /// **'Preparing your experience'**
  String get loadingMessage;

  /// Dark theme label
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Light theme label
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// English language label
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageEnglish;

  /// Arabic language label
  ///
  /// In en, this message translates to:
  /// **'AR'**
  String get languageArabic;

  /// Placeholder text
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get homeComingSoon;

  /// Placeholder body text
  ///
  /// In en, this message translates to:
  /// **'Portfolio foundation established.\nHero section coming in Phase 02.'**
  String get homeFoundation;

  /// Full hero greeting
  ///
  /// In en, this message translates to:
  /// **'Hello, I\'m Romisaa Fadel.'**
  String get heroGreeting;

  /// First line of hero greeting
  ///
  /// In en, this message translates to:
  /// **'Hello, I\'m'**
  String get heroGreetingPart1;

  /// Second line of hero greeting
  ///
  /// In en, this message translates to:
  /// **'Romisaa Fadel.'**
  String get heroGreetingPart2;

  /// Hero introduction
  ///
  /// In en, this message translates to:
  /// **'Building thoughtful, responsive, and maintainable mobile experiences with Flutter.'**
  String get heroIntroduction;

  /// Hero descriptor tag
  ///
  /// In en, this message translates to:
  /// **'Flutter • Cross-platform Development'**
  String get heroDescriptor;

  /// Get in touch button
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get heroGetInTouch;

  /// Get in touch tooltip
  ///
  /// In en, this message translates to:
  /// **'Contact Romisaa Fadel'**
  String get heroGetInTouchTooltip;

  /// CV download button
  ///
  /// In en, this message translates to:
  /// **'Download CV'**
  String get heroCvDownload;

  /// CV download tooltip
  ///
  /// In en, this message translates to:
  /// **'Download Romisaa Fadel\'s CV as PDF'**
  String get heroCvDownloadTooltip;

  /// View work button
  ///
  /// In en, this message translates to:
  /// **'View My Work'**
  String get heroViewWork;

  /// View work tooltip
  ///
  /// In en, this message translates to:
  /// **'Scroll to the projects section'**
  String get heroViewWorkTooltip;

  /// CV missing message
  ///
  /// In en, this message translates to:
  /// **'CV is not yet available. Please check back soon.'**
  String get heroCvMissing;

  /// Profile image semantic label
  ///
  /// In en, this message translates to:
  /// **'Portrait of Romisaa Fadel'**
  String get heroProfileImageLabel;

  /// About section index
  ///
  /// In en, this message translates to:
  /// **'01'**
  String get aboutSectionNumber;

  /// About section category tag
  ///
  /// In en, this message translates to:
  /// **'ABOUT ME'**
  String get aboutSectionTag;

  /// About section main heading
  ///
  /// In en, this message translates to:
  /// **'Driven by Clean Architecture, Craft & Engineering Purpose'**
  String get aboutHeadline;

  /// About lead summary
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer with a strong foundation in cross-platform mobile development and a passion for creating clean, efficient, and user-friendly applications.'**
  String get aboutLead;

  /// About bio details
  ///
  /// In en, this message translates to:
  /// **'Currently a third-year Computer Science student at Mansoura University, I combine rigorous theoretical fundamentals with over two years of hands-on Flutter experience. I specialize in scalable cross-platform architecture, reactive state management with BLoC and Cubit, and seamless backend API integrations.'**
  String get aboutBio;

  /// About mentorship details
  ///
  /// In en, this message translates to:
  /// **'Beyond development, I actively conduct Flutter training workshops and mentor students in technical communities, fostering collaborative growth and sharing practical engineering practices.'**
  String get aboutMentorship;

  /// About card: Experience metric
  ///
  /// In en, this message translates to:
  /// **'2+ Years'**
  String get aboutCardExpTitle;

  /// About card: Experience descriptor
  ///
  /// In en, this message translates to:
  /// **'Hands-on Flutter & Mobile Engineering'**
  String get aboutCardExpSub;

  /// About card: Education degree
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get aboutCardEduTitle;

  /// About card: Education university
  ///
  /// In en, this message translates to:
  /// **'Faculty of Computers & Information, Mansoura University'**
  String get aboutCardEduSub;

  /// About card: Architecture title
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture'**
  String get aboutCardArchTitle;

  /// About card: Architecture descriptor
  ///
  /// In en, this message translates to:
  /// **'MVVM · BLoC · Cubit · SOLID Principles'**
  String get aboutCardArchSub;

  /// About card: Community title
  ///
  /// In en, this message translates to:
  /// **'Community & Mentorship'**
  String get aboutCardCommunityTitle;

  /// About card: Community descriptor
  ///
  /// In en, this message translates to:
  /// **'Flutter Training & Technical Workshops'**
  String get aboutCardCommunitySub;

  /// Skills section index
  ///
  /// In en, this message translates to:
  /// **'02'**
  String get skillsSectionNumber;

  /// Skills section tag
  ///
  /// In en, this message translates to:
  /// **'TECHNICAL EXPERTISE'**
  String get skillsSectionTag;

  /// Skills section headline
  ///
  /// In en, this message translates to:
  /// **'Skill Modules & Technical Architecture'**
  String get skillsHeadline;

  /// Skills section subtitle
  ///
  /// In en, this message translates to:
  /// **'A structured breakdown of my mobile engineering stack, architectural paradigms, cloud integrations, and development workflows.'**
  String get skillsSubtitle;

  /// Skills filter: All
  ///
  /// In en, this message translates to:
  /// **'All Modules'**
  String get skillsFilterAll;

  /// Skills filter: Core
  ///
  /// In en, this message translates to:
  /// **'Core & Mobile'**
  String get skillsFilterCore;

  /// Skills filter: Architecture
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get skillsFilterArch;

  /// Skills filter: Cloud & Data
  ///
  /// In en, this message translates to:
  /// **'Cloud & Data'**
  String get skillsFilterCloud;

  /// Skills filter: Tools & UI
  ///
  /// In en, this message translates to:
  /// **'Tooling & UI'**
  String get skillsFilterTools;

  /// Skill Module 1 title
  ///
  /// In en, this message translates to:
  /// **'Core Mobile & Language Engineering'**
  String get skillsModule1Title;

  /// Skill Module 1 description
  ///
  /// In en, this message translates to:
  /// **'Building reactive, high-performance cross-platform applications with Dart and Flutter, backed by strong object-oriented principles, algorithms, and problem solving.'**
  String get skillsModule1Desc;

  /// Skill Module 2 title
  ///
  /// In en, this message translates to:
  /// **'Architecture & State Depth'**
  String get skillsModule2Title;

  /// Skill Module 2 description
  ///
  /// In en, this message translates to:
  /// **'Architecting maintainable, testable codebases using Clean Architecture, MVVM, and predictable unidirectional state management with BLoC and Cubit.'**
  String get skillsModule2Desc;

  /// Skill Module 3 title
  ///
  /// In en, this message translates to:
  /// **'Networking, APIs & Real-time Sync'**
  String get skillsModule3Title;

  /// Skill Module 3 description
  ///
  /// In en, this message translates to:
  /// **'Engineering resilient network layers with Dio, Retrofit, RESTful services, custom interceptors, automated token refresh, and structured error handling.'**
  String get skillsModule3Desc;

  /// Skill Module 4 title
  ///
  /// In en, this message translates to:
  /// **'Persistence, Security & Local Data'**
  String get skillsModule4Title;

  /// Skill Module 4 description
  ///
  /// In en, this message translates to:
  /// **'Implementing secure local persistence, relational storage with SQLite, lightweight NoSQL key-value caching with Hive, and token encryption.'**
  String get skillsModule4Desc;

  /// Skill Module 5 title
  ///
  /// In en, this message translates to:
  /// **'Cloud & Backend Integrations'**
  String get skillsModule5Title;

  /// Skill Module 5 description
  ///
  /// In en, this message translates to:
  /// **'Integrating Firebase ecosystems including Authentication, Cloud Firestore real-time streams, Cloud Storage, and Firebase Cloud Messaging (FCM).'**
  String get skillsModule5Desc;

  /// Skill Module 6 title
  ///
  /// In en, this message translates to:
  /// **'UI Craft, Motion & Developer Tooling'**
  String get skillsModule6Title;

  /// Skill Module 6 description
  ///
  /// In en, this message translates to:
  /// **'Transforming Figma designs into fluid 60fps responsive interfaces with Material Design 3, custom animations, Git version control, and DevTools profiling.'**
  String get skillsModule6Desc;

  /// Navigation: Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Navigation: About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// Navigation: Skills
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get navSkills;

  /// Navigation: My Work
  ///
  /// In en, this message translates to:
  /// **'My Work'**
  String get navWork;

  /// Navigation: Projects
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// Navigation: Experience
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get navExperience;

  /// Navigation: Education
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get navEducation;

  /// Navigation: Contact
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// Mobile menu open label
  ///
  /// In en, this message translates to:
  /// **'Open navigation menu'**
  String get navMenuOpen;

  /// Mobile menu close label
  ///
  /// In en, this message translates to:
  /// **'Close navigation menu'**
  String get navMenuClose;

  /// Experience section tag
  ///
  /// In en, this message translates to:
  /// **'03 // EXPERIENCE & TRAINING'**
  String get expSectionTag;

  /// Experience section main heading
  ///
  /// In en, this message translates to:
  /// **'Experience & Training'**
  String get expSectionHeading;

  /// Experience section subtitle
  ///
  /// In en, this message translates to:
  /// **'A journey of building, teaching, learning, and contributing to the Flutter community.'**
  String get expSectionSubtitle;

  /// Filter tab: All milestones
  ///
  /// In en, this message translates to:
  /// **'All Milestones'**
  String get expFilterAll;

  /// Filter tab: Professional & Leadership
  ///
  /// In en, this message translates to:
  /// **'Professional & Leadership'**
  String get expFilterProfessional;

  /// Filter tab: Teaching & Mentoring
  ///
  /// In en, this message translates to:
  /// **'Teaching & Mentoring'**
  String get expFilterTeaching;

  /// Filter tab: Technical Training
  ///
  /// In en, this message translates to:
  /// **'Technical Training'**
  String get expFilterTraining;

  /// Label for unstated dates
  ///
  /// In en, this message translates to:
  /// **'Date not specified'**
  String get expDateNotSpecified;

  /// DEPI Technical Track title
  ///
  /// In en, this message translates to:
  /// **'Technical Track'**
  String get expTechTrackTitle;

  /// DEPI Non-Technical Track title
  ///
  /// In en, this message translates to:
  /// **'Non-Technical Track'**
  String get expNonTechTrackTitle;

  /// Chapter A tag
  ///
  /// In en, this message translates to:
  /// **'CHAPTER 01'**
  String get expChapterATag;

  /// Chapter A title
  ///
  /// In en, this message translates to:
  /// **'Leadership & Community'**
  String get expChapterATitle;

  /// Chapter B tag
  ///
  /// In en, this message translates to:
  /// **'CHAPTER 02'**
  String get expChapterBTag;

  /// Chapter B title
  ///
  /// In en, this message translates to:
  /// **'Engineering & Learning'**
  String get expChapterBTitle;

  /// Experience type: leadership
  ///
  /// In en, this message translates to:
  /// **'LEADERSHIP & COMMUNITY'**
  String get expTypeLeadership;

  /// Experience type: instruction
  ///
  /// In en, this message translates to:
  /// **'TEACHING & MENTORING'**
  String get expTypeInstruction;

  /// Experience type: mentorship
  ///
  /// In en, this message translates to:
  /// **'MENTORING & COMMUNITY'**
  String get expTypeMentorship;

  /// Experience type: internship
  ///
  /// In en, this message translates to:
  /// **'PROFESSIONAL EXPERIENCE'**
  String get expTypeInternship;

  /// Experience type: training
  ///
  /// In en, this message translates to:
  /// **'TECHNICAL TRAINING'**
  String get expTypeTraining;

  /// Experience type: initiative
  ///
  /// In en, this message translates to:
  /// **'TECHNICAL & PROFESSIONAL DEVELOPMENT'**
  String get expTypeInitiative;

  /// Entry 1 role
  ///
  /// In en, this message translates to:
  /// **'Head — Flutter Circle'**
  String get expEntry1Role;

  /// Entry 1 organization
  ///
  /// In en, this message translates to:
  /// **'IEEE Mansoura Computer Society Chapter'**
  String get expEntry1Org;

  /// Entry 1 period
  ///
  /// In en, this message translates to:
  /// **'2025–2026'**
  String get expEntry1Period;

  /// Entry 1 description
  ///
  /// In en, this message translates to:
  /// **'Actively participated in the Flutter Circle, contributing to discussions, activities, and events related to Flutter development.'**
  String get expEntry1Desc;

  /// No description provided for @expEntry1Tag1.
  ///
  /// In en, this message translates to:
  /// **'Flutter Circle'**
  String get expEntry1Tag1;

  /// No description provided for @expEntry1Tag2.
  ///
  /// In en, this message translates to:
  /// **'Community Leadership'**
  String get expEntry1Tag2;

  /// No description provided for @expEntry1Tag3.
  ///
  /// In en, this message translates to:
  /// **'Technical Events'**
  String get expEntry1Tag3;

  /// Entry 2 role
  ///
  /// In en, this message translates to:
  /// **'Flutter Instructor — Flutter Bootcamp'**
  String get expEntry2Role;

  /// Entry 2 organization
  ///
  /// In en, this message translates to:
  /// **'BreakinPoint Team'**
  String get expEntry2Org;

  /// Entry 2 period
  ///
  /// In en, this message translates to:
  /// **'2025'**
  String get expEntry2Period;

  /// Entry 2 description
  ///
  /// In en, this message translates to:
  /// **'Led a 1.5-month Flutter bootcamp, guiding participants from fundamentals to final project development. Provided hands-on training, follow-up, and individual support throughout the bootcamp.'**
  String get expEntry2Desc;

  /// No description provided for @expEntry2Tag1.
  ///
  /// In en, this message translates to:
  /// **'1.5-Month Bootcamp'**
  String get expEntry2Tag1;

  /// No description provided for @expEntry2Tag2.
  ///
  /// In en, this message translates to:
  /// **'Hands-on Training'**
  String get expEntry2Tag2;

  /// No description provided for @expEntry2Tag3.
  ///
  /// In en, this message translates to:
  /// **'Project Coaching'**
  String get expEntry2Tag3;

  /// Entry 3 role
  ///
  /// In en, this message translates to:
  /// **'Flutter Instructor — Technical Gates 5'**
  String get expEntry3Role;

  /// Entry 3 organization
  ///
  /// In en, this message translates to:
  /// **'CIS Team'**
  String get expEntry3Org;

  /// Entry 3 period
  ///
  /// In en, this message translates to:
  /// **'2024–2025'**
  String get expEntry3Period;

  /// Entry 3 description
  ///
  /// In en, this message translates to:
  /// **'Delivered sessions and mentored students in the Flutter track as part of the Technical Gates 5 program organized by the CIS Team. Helped participants understand core Flutter concepts and apply them in practical mini-projects.'**
  String get expEntry3Desc;

  /// No description provided for @expEntry3Tag1.
  ///
  /// In en, this message translates to:
  /// **'Curriculum Delivery'**
  String get expEntry3Tag1;

  /// No description provided for @expEntry3Tag2.
  ///
  /// In en, this message translates to:
  /// **'Core Concepts'**
  String get expEntry3Tag2;

  /// No description provided for @expEntry3Tag3.
  ///
  /// In en, this message translates to:
  /// **'Mini-Projects'**
  String get expEntry3Tag3;

  /// Entry 4 role
  ///
  /// In en, this message translates to:
  /// **'Flutter Mentor'**
  String get expEntry4Role;

  /// Entry 4 organization
  ///
  /// In en, this message translates to:
  /// **'CIS Team, Mansoura University'**
  String get expEntry4Org;

  /// Entry 4 period
  ///
  /// In en, this message translates to:
  /// **'2024–2025'**
  String get expEntry4Period;

  /// Entry 4 description
  ///
  /// In en, this message translates to:
  /// **'Supported junior members in understanding Flutter concepts and solving coding problems. Assisted in organizing learning sessions and guiding students through projects and tasks.'**
  String get expEntry4Desc;

  /// No description provided for @expEntry4Tag1.
  ///
  /// In en, this message translates to:
  /// **'Junior Mentoring'**
  String get expEntry4Tag1;

  /// No description provided for @expEntry4Tag2.
  ///
  /// In en, this message translates to:
  /// **'Problem Solving'**
  String get expEntry4Tag2;

  /// No description provided for @expEntry4Tag3.
  ///
  /// In en, this message translates to:
  /// **'Learning Sessions'**
  String get expEntry4Tag3;

  /// Entry 5 role
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer Intern'**
  String get expEntry5Role;

  /// Entry 5 organization
  ///
  /// In en, this message translates to:
  /// **'Growfet'**
  String get expEntry5Org;

  /// Entry 5 period — omitted if unknown
  ///
  /// In en, this message translates to:
  /// **''**
  String get expEntry5Period;

  /// Entry 5 description
  ///
  /// In en, this message translates to:
  /// **'• Developed and maintained mobile applications using Flutter and Dart.\n• Implemented clean and scalable UI following modern design principles.\n• Integrated RESTful APIs and managed application state.\n• Debugged issues and optimized app performance for a better user experience.\n• Collaborated within a team using best practices and version control.'**
  String get expEntry5Desc;

  /// No description provided for @expEntry5Tag1.
  ///
  /// In en, this message translates to:
  /// **'Flutter & Dart'**
  String get expEntry5Tag1;

  /// No description provided for @expEntry5Tag2.
  ///
  /// In en, this message translates to:
  /// **'REST APIs'**
  String get expEntry5Tag2;

  /// No description provided for @expEntry5Tag3.
  ///
  /// In en, this message translates to:
  /// **'State Management'**
  String get expEntry5Tag3;

  /// No description provided for @expEntry5Tag4.
  ///
  /// In en, this message translates to:
  /// **'Git & Best Practices'**
  String get expEntry5Tag4;

  /// Entry 6 role
  ///
  /// In en, this message translates to:
  /// **'Flutter Trainee — ITI Winter Internship'**
  String get expEntry6Role;

  /// Entry 6 organization
  ///
  /// In en, this message translates to:
  /// **'Information Technology Institute (ITI)'**
  String get expEntry6Org;

  /// Entry 6 period
  ///
  /// In en, this message translates to:
  /// **'January 2025'**
  String get expEntry6Period;

  /// Entry 6 duration label
  ///
  /// In en, this message translates to:
  /// **'60 Hours'**
  String get expEntry6Duration;

  /// Entry 6 description
  ///
  /// In en, this message translates to:
  /// **'Completed practical Flutter training covering:\n• Flutter widgets and UI design.\n• API integration and data handling.\n• State management techniques.\n• Introduction to freelancing and real-world project planning.'**
  String get expEntry6Desc;

  /// No description provided for @expEntry6Tag1.
  ///
  /// In en, this message translates to:
  /// **'Widgets & UI Design'**
  String get expEntry6Tag1;

  /// No description provided for @expEntry6Tag2.
  ///
  /// In en, this message translates to:
  /// **'API Integration'**
  String get expEntry6Tag2;

  /// No description provided for @expEntry6Tag3.
  ///
  /// In en, this message translates to:
  /// **'State Management'**
  String get expEntry6Tag3;

  /// No description provided for @expEntry6Tag4.
  ///
  /// In en, this message translates to:
  /// **'Freelancing Basics'**
  String get expEntry6Tag4;

  /// Entry 7 role
  ///
  /// In en, this message translates to:
  /// **'Digital Egypt Pioneers Initiative (DEPI)'**
  String get expEntry7Role;

  /// Entry 7 organization
  ///
  /// In en, this message translates to:
  /// **'DEPI — Ministry of Communications & Information Technology'**
  String get expEntry7Org;

  /// Entry 7 period
  ///
  /// In en, this message translates to:
  /// **'June 2025'**
  String get expEntry7Period;

  /// Entry 7 description
  ///
  /// In en, this message translates to:
  /// **'• Technical Track: Studying the Cross Platform track using Flutter, focusing on building scalable, multi-platform mobile applications.\n• Non-Technical Track: Participating in sessions on soft skills, freelancing basics, communication, and career development.'**
  String get expEntry7Desc;

  /// No description provided for @expEntry7Tag1.
  ///
  /// In en, this message translates to:
  /// **'Cross Platform Track'**
  String get expEntry7Tag1;

  /// No description provided for @expEntry7Tag2.
  ///
  /// In en, this message translates to:
  /// **'Scalable Applications'**
  String get expEntry7Tag2;

  /// No description provided for @expEntry7Tag3.
  ///
  /// In en, this message translates to:
  /// **'Soft Skills & Freelancing'**
  String get expEntry7Tag3;

  /// No description provided for @expEntry7Tag4.
  ///
  /// In en, this message translates to:
  /// **'Career Development'**
  String get expEntry7Tag4;

  /// Projects section tag
  ///
  /// In en, this message translates to:
  /// **'04 // FEATURED WORK & CASE STUDIES'**
  String get projectsSectionTag;

  /// Projects section heading
  ///
  /// In en, this message translates to:
  /// **'Featured Projects'**
  String get projectsSectionHeading;

  /// Projects section subtitle
  ///
  /// In en, this message translates to:
  /// **'A curated selection of real-world mobile applications, AI-integrated solutions, and production Flutter architectures.'**
  String get projectsSectionSubtitle;

  /// Filter: All projects
  ///
  /// In en, this message translates to:
  /// **'All Projects'**
  String get projectsFilterAll;

  /// Filter: AI & Health
  ///
  /// In en, this message translates to:
  /// **'AI & Health'**
  String get projectsFilterAi;

  /// Filter: Social Impact
  ///
  /// In en, this message translates to:
  /// **'Social Impact'**
  String get projectsFilterCommunity;

  /// Filter: Platforms
  ///
  /// In en, this message translates to:
  /// **'Platforms'**
  String get projectsFilterPlatforms;

  /// Featured project badge
  ///
  /// In en, this message translates to:
  /// **'FEATURED PROJECT'**
  String get projectFeaturedBadge;

  /// GitHub button label
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get projectGithubBtn;

  /// Source code tooltip
  ///
  /// In en, this message translates to:
  /// **'Open repository on GitHub'**
  String get projectSourceCodeTooltip;

  /// Coming soon badge
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get projectComingSoon;

  /// Google Play button
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get projectPlayStoreBtn;

  /// App Store button
  ///
  /// In en, this message translates to:
  /// **'App Store'**
  String get projectAppStoreBtn;

  /// Store release coming soon tooltip
  ///
  /// In en, this message translates to:
  /// **'Application store release coming soon'**
  String get projectStoreInactiveTooltip;

  /// Key contributions label
  ///
  /// In en, this message translates to:
  /// **'Key Highlights:'**
  String get projectKeyContributions;

  /// Verified technologies label
  ///
  /// In en, this message translates to:
  /// **'Technologies:'**
  String get projectVerifiedTech;

  /// NutriMind title
  ///
  /// In en, this message translates to:
  /// **'NutriMind — Nutrition & Mental Wellness App'**
  String get projectNutrimindTitle;

  /// NutriMind category
  ///
  /// In en, this message translates to:
  /// **'AI & Mental Wellbeing'**
  String get projectNutrimindCategory;

  /// NutriMind description
  ///
  /// In en, this message translates to:
  /// **'An intelligent nutrition and mental-wellness companion built with Flutter, combining AI-powered meal analysis, nutritional tracking, daily wellness tips, and a conversational assistant in one personalized experience.'**
  String get projectNutrimindDesc;

  /// NutriMind feature 1
  ///
  /// In en, this message translates to:
  /// **'AI-powered meal scanning & instant macronutrient breakdown (calories, protein, carbs, fat)'**
  String get projectNutrimindFeature1;

  /// NutriMind feature 2
  ///
  /// In en, this message translates to:
  /// **'Breakfast, lunch, and dinner tracking with comprehensive nutrition dashboard'**
  String get projectNutrimindFeature2;

  /// NutriMind feature 3
  ///
  /// In en, this message translates to:
  /// **'Meal history synced through Cloud Firestore & Firebase Authentication'**
  String get projectNutrimindFeature3;

  /// NutriMind feature 4
  ///
  /// In en, this message translates to:
  /// **'Conversational AI nutrition assistant & daily mental wellness guidance'**
  String get projectNutrimindFeature4;

  /// Qoot title
  ///
  /// In en, this message translates to:
  /// **'Qoot — Food Donation Application'**
  String get projectQootTitle;

  /// Qoot category
  ///
  /// In en, this message translates to:
  /// **'Charity & Social Impact'**
  String get projectQootCategory;

  /// Qoot role
  ///
  /// In en, this message translates to:
  /// **'Charity Module Lead (DEPI Team)'**
  String get projectQootRole;

  /// Qoot description
  ///
  /// In en, this message translates to:
  /// **'Developed the complete Charity module for the Qoot food-donation application using Flutter and Bloc/Cubit architecture within a multidisciplinary DEPI team. Implemented core donation workflows, reservation tracking, charity profile management, and responsive Clean Architecture screens to reduce food waste and support charities.'**
  String get projectQootDesc;

  /// Qoot feature 1
  ///
  /// In en, this message translates to:
  /// **'Complete Charity Module & Donation Reservation Workflow'**
  String get projectQootFeature1;

  /// Qoot feature 2
  ///
  /// In en, this message translates to:
  /// **'Clean Architecture, BLoC State Management & REST APIs'**
  String get projectQootFeature2;

  /// Qoot feature 3
  ///
  /// In en, this message translates to:
  /// **'Real-world initiative to reduce food waste and empower charities'**
  String get projectQootFeature3;

  /// Sanad title
  ///
  /// In en, this message translates to:
  /// **'Sanad — Legal Services Platform'**
  String get projectSanadTitle;

  /// Sanad category
  ///
  /// In en, this message translates to:
  /// **'Legal Tech & Advisory'**
  String get projectSanadCategory;

  /// Sanad description
  ///
  /// In en, this message translates to:
  /// **'Developed a mobile application that connects clients with lawyers for legal consultations and case representation through a user-friendly platform. Enables browsing lawyers based on experience, education, pricing, and client reviews, viewing detailed lawyer profiles, and communicating seamlessly. Includes an AI-powered chatbot to assist users and support lawyers in analyzing cases and finding similar legal references.'**
  String get projectSanadDesc;

  /// Sanad feature 1
  ///
  /// In en, this message translates to:
  /// **'Intelligent Lawyer Discovery, Verified Profiles & Client Reviews'**
  String get projectSanadFeature1;

  /// Sanad feature 2
  ///
  /// In en, this message translates to:
  /// **'Seamless Legal Consultations & Case Representation Booking'**
  String get projectSanadFeature2;

  /// Sanad feature 3
  ///
  /// In en, this message translates to:
  /// **'AI Legal Chatbot for Case Analysis & Reference Discovery'**
  String get projectSanadFeature3;

  /// Rafeeq title
  ///
  /// In en, this message translates to:
  /// **'Rafeeq — Founder & Investor Platform'**
  String get projectRafeeqTitle;

  /// Rafeeq category
  ///
  /// In en, this message translates to:
  /// **'Startups & Venture Capital'**
  String get projectRafeeqCategory;

  /// Rafeeq description
  ///
  /// In en, this message translates to:
  /// **'Developed a mobile application connecting startup founders with investors to support startup ideas and funding opportunities through an interactive platform. Enables founders to showcase projects and allows investors to browse, filter, and discover vetted startup concepts based on interests, fostering smoother investment and collaboration.'**
  String get projectRafeeqDesc;

  /// Rafeeq feature 1
  ///
  /// In en, this message translates to:
  /// **'Startup Pitch Showcase & Multi-Step Creation Wizard'**
  String get projectRafeeqFeature1;

  /// Rafeeq feature 2
  ///
  /// In en, this message translates to:
  /// **'Custom Filtering & Opportunity Discovery for Investors'**
  String get projectRafeeqFeature2;

  /// Rafeeq feature 3
  ///
  /// In en, this message translates to:
  /// **'Direct Collaboration Channel Between Founders and Angels'**
  String get projectRafeeqFeature3;

  /// Contact section tag
  ///
  /// In en, this message translates to:
  /// **'05 // GET IN TOUCH'**
  String get contactSectionTag;

  /// Contact section heading
  ///
  /// In en, this message translates to:
  /// **'Let\'s Connect'**
  String get contactSectionHeading;

  /// Contact section subtitle
  ///
  /// In en, this message translates to:
  /// **'Have an opportunity, a project idea, or a chance to collaborate? I\'d love to hear from you.'**
  String get contactSectionSubtitle;

  /// Contact location
  ///
  /// In en, this message translates to:
  /// **'Mansoura, Dakahlia, Egypt'**
  String get contactLocation;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get contactEmailLabel;

  /// Phone label
  ///
  /// In en, this message translates to:
  /// **'Phone / WhatsApp'**
  String get contactPhoneLabel;

  /// LinkedIn label
  ///
  /// In en, this message translates to:
  /// **'LinkedIn Profile'**
  String get contactLinkedInLabel;

  /// GitHub label
  ///
  /// In en, this message translates to:
  /// **'GitHub Repositories'**
  String get contactGitHubLabel;

  /// Copy tooltip
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get contactCopyTooltip;

  /// Copied snackbar
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard!'**
  String get contactCopiedSnackbar;

  /// Send email button
  ///
  /// In en, this message translates to:
  /// **'Send an Email'**
  String get contactSendEmailBtn;

  /// Call button
  ///
  /// In en, this message translates to:
  /// **'Call / Dial'**
  String get contactCallBtn;

  /// View profile button
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get contactViewProfileBtn;

  /// Explore GitHub button
  ///
  /// In en, this message translates to:
  /// **'Explore GitHub'**
  String get contactViewGithubBtn;

  /// Availability badge
  ///
  /// In en, this message translates to:
  /// **'Available for New Opportunities'**
  String get contactAvailabilityBadge;

  /// Availability description
  ///
  /// In en, this message translates to:
  /// **'Open to Full-time Flutter Developer positions, remote roles, and innovative freelance mobile projects.'**
  String get contactAvailabilityDesc;

  /// Footer tagline
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer building thoughtful, scalable mobile experiences.'**
  String get footerTagline;

  /// Footer navigation title
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get footerQuickLinksTitle;

  /// Footer socials title
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get footerSocialsTitle;

  /// Footer copyright
  ///
  /// In en, this message translates to:
  /// **'© {year} Romisaa Fadel. All rights reserved.'**
  String footerCopyright(String year);

  /// Back to top button
  ///
  /// In en, this message translates to:
  /// **'Back to Top'**
  String get footerBackToTop;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
