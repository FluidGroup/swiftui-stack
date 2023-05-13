
![stack](https://github.com/FluidGroup/swiftui-stack/assets/1888355/58a5ee2f-c44b-4aa1-8254-34a2b59cda1b)

Custom Stack Navigation for SwiftUI
---
This library provides a custom container view for SwiftUI that offers an alternative to the standard NavigationStack. It aims to improve the customizability of transitions during screen navigation by moving away from the behaviors of UINavigationController and UINavigationBar.

Features
---
- Customizable transitions during screen navigation
- Contextual animations similar to iOS home screen app icons and app screens
- Familiar API to NavigationView and NavigationStack for ease of use
- Path support for restoring previously navigated views

Getting Started
---
To use this library, you'll need to work with three main symbols: Stack, StackLink, and StackUnwindLink.

Example Usage
---
1. Import the SwiftUIStack module in your SwiftUI view file:

```swift
import SwiftUIStack
```

2. Use the Stack container in your view hierarchy:

```swift
var body: some View {
  Stack {
    // Your views here...
  }
}
```

3. Create navigation links using StackLink with your desired transition and destination:

```swift
StackLink(transition: .slide, value: someValue) {
  Text("Navigate to detail view")
}
```

You can also set the matched transition in the transition parameter using a unique identifier and a namespace:

```swift
StackLink(transition: .matched(identifier: user.id, in: local), value: someValue) {
  Text("Navigate to detail view with matched transition")
}
```

4. Optionally, use StackUnwindLink to create a navigation link back to the previous view:

```swift
StackUnwindLink {
  Text("Back to previous view")
}
```

Unwind Context
---
In stacked views, you can access the unwindContext as an EnvironmentValue. You can pass the unwindContext to a StackUnwindLink. This allows you to explicitly specify the stack that triggers the unwind.

```swift
@Environment(\.stackUnwindContext) var unwindContext

StackUnwindLink(target: .specific(unwindContext)) {
  Text("Back to Menu")
}
```

StackUnwindLink Modes
---
StackUnwindLink now supports different modes for navigation. To navigate back to the root of the target stack, use the .all mode.

```swift
StackUnwindLink(mode: .all) {
  Text("Back to Root")
}
```

Nested Stacks
---
This technique is useful for nested stacks when you need to send a message across multiple levels of the hierarchy. By using the unwindContext in conjunction with StackUnwindLink, you can effectively communicate between nested stacks and navigate through different levels of the view hierarchy.

Installation
---
(Include instructions for installation via Swift Package Manager, CocoaPods, or other methods, if applicable)

Contributing
---
(Include instructions for contributing to the project, such as opening issues, submitting pull requests, and any other relevant information)

License
---
This project is licensed under the Apache License, Version 2.0. See the [LICENSE](LICENSE) file for more information.
