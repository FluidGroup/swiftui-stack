
import SwiftUI
import Stack

struct BookNesting: View {
  var body: some View {
    
    VStack {      
      HStack {
        Text("A")
          .font(.title)
        Spacer()
      }
      Stack(identifier: .init("A")) {
        
        Group {
          StackLink {
            VStack {
              Color.purple
              StackUnwindLink {
                Text("Pop")
              }
            }
          } label: {
            Text("Push")
          }
        }
        
        VStack {
          
          HStack {
            Text("B")
              .font(.title)
            Spacer()
          }
          
          Stack(identifier: .init("B")) {
            
            Group {
              StackLink {
                VStack {
                  Color.purple
                  StackUnwindLink {
                    Text("Pop")
                  }
                }
              } label: {
                Text("Push")
              }
            }
            
            VStack {
              
              HStack {
                Text("C")
                  .font(.title)
                Spacer()
              }
              Stack(identifier: .init("C")) {
                
                Group {
                  StackLink {
                    VStack {
                      Color.purple
                      StackUnwindLink {
                        Text("Pop")
                      }
                    }
                  } label: {
                    Text("Push")
                  }
                }

              }
            }
            .padding(.leading, 20)
            
          }
        }
        .padding(.leading, 20)
      }
      .padding(20)
    }

  }
}

struct BookNesting_Previews: PreviewProvider {
  static var previews: some View {
    BookNesting()
  }
}
