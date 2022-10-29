import XCTest
@testable import Stack
import ViewInspector
import SwiftUI

final class StackTests: XCTestCase {
  
  func testExample() throws {
    let sut = Text("Completed by \(72.51, specifier: "%.1f")%").font(.caption)
    
    let string = try sut.inspect().text().string(locale: Locale(identifier: "es"))
    XCTAssertEqual(string, "Completado por 72,5%")
    
    XCTAssertEqual(try sut.inspect().text().attributes().font(), .caption)
  }
}
