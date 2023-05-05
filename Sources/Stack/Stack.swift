import SwiftUI

/// A typealias a Stack using ``NativeStack``
public typealias Stack<Data, Root: View> = AbstractStack<Data, Root, NativeStackDisplay<ModifiedContent<Root, AbstractStackRootModifier>>>

