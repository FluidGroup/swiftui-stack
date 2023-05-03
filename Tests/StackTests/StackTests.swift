import SwiftUI
import ViewInspector
import XCTest

@testable import Stack

final class StackTests: XCTestCase {

  @MainActor
  func test_stack_displays_root() throws {

    let stack = Stack {
      Text("").id("Root")
    }

    _ = try stack.inspect().find(viewWithId: "Root")
  }

  @MainActor
  func test_stack_push_destination() throws {
    // TODO:

  }
}

