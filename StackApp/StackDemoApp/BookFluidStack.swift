
import SwiftUI
import FluidStack

struct BookFluidStack: View {
  
  @State var momentA: Bool = false
  @State var momentB: Bool = false
  
  @Binding var path: StackPath
  
  @State var counter: Int = 0
  
  init(path: Binding<StackPath>) {
    self._path = path
  }
  
  var body: some View {
    
    VStack {
      
      StackUnwindLink {
        Text("Back")
      }
      
      HStack {
        Button("\(counter.description)") {
          counter += 1
        }
        Button("Toggle Moment A") {
          momentA.toggle()
        }
        
        Button("Set 1") {
          path = .init()
          path.append(M<A>(id: "1"))
          path.append(M<B>(id: "2"))
          path.append(M<C>(id: "3"))
        }
        
        Button("Set 2") {
          path = .init()
          path.append(M<A>(id: "4"))
          path.append(M<B>(id: "5"))
          path.append(M<C>(id: "6"))
        }
        
        Button("Append") {
          path.append(M<A>(id: "4"))
        }
      }
      
      FluidStack(path: $path) {
        
        VStack {
          Text("Root")
          
          StackLink(value: M<A>()) {
            Text("Open A")
          }
          
          StackLink(value: M<B>()) {
            Text("Open B")
          }
          
          StackLink(value: M<C>()) {
            Text("Open C")
          }
          
          Button("Toggle Alert A") {
            momentA = true
          }
          
          Button("Toggle Alert B") {
            momentB = true
          }
        }
        .stackDestination(for: M<A>.self) { model in
          ZStack {
            Color.red
            
            VStack {
              StatefulPage(title: "\(model)")
              
              StackLink(value: M<B>()) {
                Text("Open B")
              }
              
              StackUnwindLink {
                Text("Pop")
              }
            }
          }
          
        }
        .stackDestination(for: M<B>.self) { model in
          ZStack {
            Color.yellow
            VStack {
              Text(String(describing: model))
              
              StackLink(value: M<A>()) {
                Text("Open A")
              }
              
              StackUnwindLink {
                Text("Pop")
              }
            }
          }
        }
        .stackDestination(for: M<C>.self) { model in
          ZStack {
            Color.purple
            VStack {
              Text(String(describing: model))
              StackUnwindLink {
                Text("Pop")
              }
            }
          }
        }
        .stackDestination(isPresented: $momentA) {
          ZStack {
            Color.purple
            VStack {
              Text("Moment A")
              StackUnwindLink {
                Text("Pop")
              }
            }
          }
        }
        .stackDestination(isPresented: $momentB) {
          ZStack {
            Color.purple
            VStack {
              Text("Moment B")
              StackUnwindLink {
                Text("Pop")
              }
            }
          }
        }
      }
      
    }
  }
}

