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
    Stack {
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
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
