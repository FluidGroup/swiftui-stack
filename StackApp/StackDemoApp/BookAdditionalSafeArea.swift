
import SwiftUI
import Stack

struct BookAdditionalSafeArea: View {
  
  var body: some View {
    
//    if #available(iOS 15.0, *) {
//      Color.red
//        .background(Color.blue.ignoresSafeArea())
//        .safeAreaInset(edge: .bottom, alignment: .center, spacing: 10) {
//          Text("Hello")
//        }
//    } else {
//      // Fallback on earlier versions
    
    AdditionalSafeArea(.init(top: 20, leading: 20, bottom: 20, trailing: 20)) {
      Color.red
    }
        
  }
  
}
