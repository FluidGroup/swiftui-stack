import SwiftUI

struct BookNavigationStack: View {
  
  var body: some View {
    
    if #available(iOS 16, *) {
      _BookNavigationStack()
    }
    
  }
}

@available(iOS 16, *)
private struct _BookNavigationStack: View {
  
  struct A: Hashable {
    var id: String
  }
  
  struct B: Hashable {
    var id: String
  }
  
  struct C: Hashable {
    var id: String
  }
  
  @State var isPresented = false
  @State var path: NavigationPath = .init([A(id: "A")])
  
  var body: some View {
    
    VStack {
      
      HStack {
        Button {
          path = .init()
          path.append(A(id: "A"))
          path.append(A(id: "B"))
          path.append(A(id: "C"))
        } label: {
          Text("Set")
        }
        
        Button {
          path.append(A(id: UUID().uuidString))
        } label: {
          Text("Append")
        }
        
        Button {
          isPresented = true
        } label: {
          Text("Momentary")
        }
        
      }
      
      NavigationStack(path: $path) {
        Group {
          List {
            Text("Root")
            
            NavigationLink(value: A(id: UUID().description)) {
              Text("Open A")
            }
            
            NavigationLink(value: B(id: UUID().description)) {
              Text("Open B")
            }
            
            NavigationLink(value: C(id: UUID().description)) {
              Text("Open C")
            }
            
            NavigationLink.init {
              Text("Inline destination")
            } label: {
              Text("Open inline")
            }
            
            Button("Present") {
              isPresented = true
            }
                     
          }
        }
        
        .navigationDestination(for: B.self) { value in
          Text("View for B")
        }
        .navigationDestination(for: A.self) { value in
          Group {
            
            StatefulPage(title: "A, \(value.id)")
            
            NavigationLink(value: C(id: UUID().description)) {
              Text("Open C")
            }
            NavigationLink(value: A(id: UUID().description)) {
              Text("Open A")
            }
            NavigationLink.init {
              VStack {
                Text("Inline destination")
              }
            } label: {
              Text("Open inline")
            }
          }
          .navigationDestination(for: A.self) { value in
            Text("Another view for A")
          }
          .navigationDestination(for: C.self) { value in
            Text("View for C")
          }
        }
        .navigationDestination(isPresented: $isPresented) {
          Text("Present")
        }
      }
    }
    .onChange(of: path) { newValue in
      print(newValue)
    }
    
  }
}
