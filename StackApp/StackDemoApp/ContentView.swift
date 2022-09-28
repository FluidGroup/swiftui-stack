//
//  ContentView.swift
//  StackDemoApp
//
//  Created by Muukii on 2022/09/29.
//

import SwiftUI
import Stack

struct ContentView: View {
  var body: some View {
    Stack(identifier: .init("root")) {
      StackLink {
        BookStack()
          .background(Color.white)
      } label: {
        Text("Stack")
      }
      StackLink {
        BookStackNoPath()
          .background(Color.white)
      } label: {
        Text("Stack no path")
      }
      StackLink {
        BookNesting()
      } label: {
        Text("Nesting")
      }

      TransitionView()
    }
  }
}

struct TransitionView: View {
  
  struct ViewBox: View, Identifiable {
    
    var id: String {
      model.id
    }
    
    var model: M<A>
    var view: AnyView
    
    var body: some View {
      view
    }
  }
  
  @State var items: [ViewBox] = []
  
  var body: some View {
    VStack {
      Button("+") {
        withAnimation {
          items.append(.init(
            model: .init(),
            view: .init(
              Circle()
                .opacity(0.2)
                .frame(width: 30, height: 30))))
        }
      }
      Button("-") {
        withAnimation {
          _ = items.removeLast()
        }
      }
      ZStack {
        ForEach(items) { item in
          item
            .transition(.scale)
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
