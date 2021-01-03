<h1 align="center">Dev<a href="https://github.com/DevUtilsApp/DevUtils-app#">Utils</a>.app</h1>
<h3 align="center">Developer Utilities for macOS</h3>

<p align="center">
  <img src="https://devutils.app/screenshot-dark.png">
  <br/>
  <a href="https://devutils.app/#download">🚀 &nbsp; Download</a> | <a href="https://devutils.app/demo">🎬 &nbsp; Demo & Screenshots</a> | <a href="https://github.com/DevUtilsApp/DevUtils-app/tree/master/TINOBHNYWE">📝 &nbsp; View source</a> | <a href="https://twitter.com/devutils_app">📣 &nbsp; Follow on Twitter</a>
</p>

# Overview

<b>DevUtils</b> helps you with your tiny daily tasks with just a single click! It's totally open source and work offline. You can buy the pre-built app by visiting the website https://devutils.app or you can build the app from source by yourself!

# A friendly note from author
DevUtils is a **paid open source** app. That means I'm selling the [pre-built version of the app](https://devutils.app) to earn some revenue for my time. I'm glad that you like the app and you are free to build it for your own use. I trust that you will not redistribute the app in any other means. Thank you very much! :)

# Source code
Development environment:
- Swift 5.1+
- Xcode 11.1+
- Swift Package Manager
- Carthage

# Build Instructions
 - Clone repository.
 - Bootstrap carthage, this will install the required dependencies for the app:
 
     `carthage bootstrap --platform macOS`
 
 - Update signing Team to be your Personal or organizational Team in Xcode. This is needed to build the app locally. As the signing step could be different between Xcode versions, I may not be able to support you on this (help wanted, feel free to open a PR to update this instruction). Please also check these articles to see if it helps:
   - https://developer.apple.com/support/code-signing/
   - https://help.apple.com/xcode/mac/current/#/dev60b6fbbc7 
 - Run the app in Xcode.
 
# Contributing

Please see [CONTRIBUTING.md](https://github.com/DevUtilsApp/DevUtils-app/blob/master/CONTRIBUTING.md)

# Contact
- **FAQs**: Please check https://devutils.app/faqs
- **Email**: admin@devutils.app
- **Twitter**: https://twitter.com/devutils_app
