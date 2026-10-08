# iClassicMsg

A revival of the classic iMessage experience, bringing back the nostalgic iOS 18 Messages interface with support for both iPhone and Android.

iClassicMsg aims to bring people together in one familiar messaging experience, without making both platforms look identical. On iPhone, the app takes inspiration from the classic Apple Messages design. On Android, it follows the familiar look and feel of Google Messages.

> **Project status: Early development.** iClassicMsg is being built, and the ideas described below are the project's goals—not a promise that every feature is available today.

## Table of contents

- [About iClassicMsg](#about-iclassicmsg)
- [The idea](#the-idea)
- [A familiar experience on every platform](#a-familiar-experience-on-every-platform)
- [Bubble colors](#bubble-colors)
- [Planned features](#planned-features)
- [Design goals](#design-goals)
- [Platforms](#platforms)
- [Project status](#project-status)
- [Getting involved](#getting-involved)
- [Feedback and bug reports](#feedback-and-bug-reports)
- [A note about Apple](#a-note-about-apple)

## About iClassicMsg

Remember the classic Messages experience? iClassicMsg is a project built around bringing back that familiar look and feel while making it possible for iPhone and Android users to chat with each other in the same app.

The goal is simple: **a classic Messages experience on iPhone, a familiar Google Messages-style experience on Android, and one shared place to talk.**

The two apps do not need to look exactly alike. Each platform can feel at home on its own device while still being part of the same messaging experience.

## The idea

Messaging should feel familiar, not complicated. iClassicMsg is being designed around a few simple ideas:

- Bring back the classic iOS Messages look that people remember.
- Let iPhone and Android users chat with each other.
- Keep the Android interface familiar to Android users.
- Support both individual conversations and group chats.
- Make it easy to recognize which platform a person is using.
- Keep the app focused on conversations rather than unnecessary extras.

iClassicMsg is a standalone project. It is not intended to replace the Messages app that comes with an iPhone.

## A familiar experience on every platform

### iPhone

The iOS version aims to recreate the familiar appearance of the classic iOS 18 Messages app. That includes the overall conversation layout, familiar navigation, message bubbles, and the clean, straightforward style of older iOS interfaces.

The design goal is to keep that classic look even when the app runs on newer versions of iOS. The implementation will use SwiftUI, with custom components where needed to keep the appearance consistent.

### Android

The Android version aims to feel natural on Android devices, taking inspiration from Google Messages rather than forcing an iPhone interface onto Android.

That means an Android-friendly layout and interactions, while keeping conversations compatible with the iPhone version.

### One shared experience

Although the interfaces are platform-specific, iPhone and Android users are intended to be able to communicate with one another through iClassicMsg. A conversation should still feel like the same conversation, regardless of which phone each person uses.

## Bubble colors

One of the fun parts of iClassicMsg is the platform-based bubble color idea.

- **Blue** represents messages associated with iPhone users.
- **Green** represents messages associated with Android users in the iOS interface.

The aim is to make the platform distinction visible in the conversation instead of hiding it. The colors are a visual choice for iClassicMsg; they do not mean that someone on one platform gets a different level of access to the app's features.

## Planned features

The following are goals for the project as development progresses. They may change as the app takes shape.

- **One-to-one conversations** — chat with another iClassicMsg user.
- **Cross-platform messaging** — communicate between iPhone and Android.
- **Group chats** — bring friends together in a shared conversation, even when they use different kinds of phones.
- **Group names and photos** — make group conversations easier to recognize.
- **Platform-based bubble colors** — distinguish iPhone and Android participants visually.
- **Conversation history** — make it easy to return to previous conversations.
- **Familiar platform interfaces** — classic Messages-inspired styling on iPhone and Google Messages-inspired styling on Android.
- **A straightforward experience** — keep the everyday act of sending and reading messages simple.

These features are part of the direction for iClassicMsg. Please check the repository's current code and project updates to see what is actually implemented.

## Design goals

iClassicMsg has a clear design direction:

- **Classic, not redesigned.** The iPhone interface should take inspiration from the iOS 18-era Messages app instead of adopting the newer Liquid Glass look.
- **Native to each platform.** The iPhone and Android apps should respect the conventions users already know.
- **Simple and readable.** Conversations should be easy to follow and comfortable to use.
- **Consistent where it matters.** Both clients should support the same core conversations and work together as parts of one app.
- **No unnecessary clutter.** The interface should focus on people and their messages.

The goal is not to make Android pretend to be iOS or to make iOS pretend to be Android. It is to bring the same messaging experience to both, using an interface that suits each platform.

## Platforms

### iOS

The iOS client is planned in SwiftUI, with a minimum deployment target of iOS 15.4. The interface will use custom SwiftUI styling and components where needed to preserve the intended classic appearance on newer system versions.

### Android

An Android client is part of the plan, with an interface inspired by Google Messages and familiar Android design conventions.

Both clients are part of the same project, but their layouts can be built in ways that make sense for their respective platforms.

## Project status

iClassicMsg is in early development. The project is starting with its identity and design direction, and the implementation will grow over time.

At this stage, the feature list above describes the intended direction rather than a list of finished features. There may not yet be an installable app or a release available for everyday use.

As development progresses, this README can be updated with screenshots, setup instructions, supported versions, and release information.

## Getting involved

iClassicMsg is intended to be an open-source project, and contributions may become useful as the codebase grows.

If you want to help:

1. Explore the repository and check what is currently implemented.
2. Look for an existing issue or discussion about the change you have in mind.
3. Keep proposed changes focused and explain what they improve.
4. For interface changes, describe which platform they affect and how they fit the project's design goals.
5. Be respectful and constructive when discussing ideas or reviewing contributions.

Before spending time on a large change, it is a good idea to open an issue to discuss the idea first. That helps keep the project moving in a consistent direction.

## Feedback and bug reports

Feedback is welcome, especially when it helps make the app easier to understand or more comfortable to use.

When reporting a bug, please include:

- Which platform you are using.
- The device and operating system version, if known.
- What you expected to happen.
- What actually happened.
- Steps to reproduce the problem, if possible.
- A screenshot, when it helps explain a visual issue.

Please avoid including private conversations or other personal information in screenshots and reports.

Suggestions for the classic iPhone interface and the Android interface are both welcome. The aim is to make each client feel right for its platform while keeping the overall experience consistent.

## A note about Apple

iClassicMsg is an independent project inspired by the classic Messages experience. It is not an official Apple product and is not affiliated with or endorsed by Apple. Apple, iMessage, and related names are trademarks of their respective owners.

---

**iClassicMsg — the classic Messages experience, reimagined for iPhone and Android.**
