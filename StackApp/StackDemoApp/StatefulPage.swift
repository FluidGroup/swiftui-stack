import SwiftUI

struct StatefulPage: View {
  
  private let title: String
  
  @State var isOn: Bool = false
  
  init(title: String) {
    self.title = title
  }
  
  var body: some View {
    VStack {
      Text(title)
      Toggle(isOn: $isOn) {
        Text("Toggle")
      }
    }
  }
  
}

