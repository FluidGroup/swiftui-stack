import SwiftUI
import Stack

@available(iOS 14, *)
struct BookStack_Grid: View {
  
  @Namespace var space
        
  var body: some View {
    
    Stack {
      
      ScrollView {
        
        HStack {
          
          VStack {
            
            itemCell(id: "1", namespace: space)
            itemCell(id: "2", namespace: space)
            
          }
          
          VStack {
            
          }
          
        }
      }
      
    }
    
  }
  
  fileprivate func itemCell(
    id: some Hashable,
    namespace: Namespace.ID
  ) -> some View {
    StackLink {
      StackUnwindLink {
        Color.purple
          .background(Color.white)
          .matchedGeometryEffect(id: id, in: namespace)
      }
    } label: {
      Color.red
        .matchedGeometryEffect(id: id, in: namespace)
        .frame(width: 100, height: 140)
    }
  }
}

@available(iOS 14, *)
enum Preview_BookStack_Grid: PreviewProvider {
  
  static var previews: some View {
    BookStack_Grid()
  }
}
