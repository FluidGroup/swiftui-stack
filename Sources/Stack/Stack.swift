import SwiftUI

public typealias Stack<Data, Root: View> = AbstractStack<Data, Root, NativeStack<Root>>

