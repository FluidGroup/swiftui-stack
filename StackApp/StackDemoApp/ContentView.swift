//
//  ContentView.swift
//  StackDemoApp
//
//  Created by Muukii on 2022/09/29.
//

import Stack
import SwiftUI

struct ContentView: View {

  @State var path1 = StackPath()
  @State var path2 = StackPath([M<A>.init()])
  @State var path3 = StackPath()

  var body: some View {
    Stack(identifier: .init("root")) {

      Button("Reset") {
        path2 = .init([M<A>.init()])
      }

      Form {

        Section {

          StackLink {
            BookStack(path: $path1)
              .background(Color.white)
          } label: {
            Text("Stack")
          }

          StackLink {
            BookFullScreenStack()
          } label: {
            Text("Stack fullscreen")
          }

          StackLink {
            BookStack_Grid()
              .background(Color.white)
          } label: {
            Text("Stack - Grid")
          }

          StackLink {
            BookStack(path: $path2)
              .background(Color.white)
          } label: {
            Text("Stack restore-path")
          }
          StackLink {
            BookStackNoPath()
              .background(Color.white)
          } label: {
            Text("Stack no path")
          }

        } header: {
          Text("Stack")
        }

        Section {

          StackLink(transition: .basic(transition: .move(edge: .bottom).animation(.smoothSpring))) {
            ZStack {
              Color.white
                .ignoresSafeArea()
              StackUnwindLink {
                Text("Pop")
              }
            }
          } label: {
            Text("Stack")
          }

        } header: {
          Text("Stack transition")
        }

        Section {

          StackLink {
            BookNavigationStack()
          } label: {
            Text("NavigationStack")
          }

          StackLink {
            BookMatchedShape()
          } label: {
            Text("Matched Shape")
          }
        } header: {
          Text("Playgrounds")
        }

        Section {

          StackLink {
            BookFluidStack(path: $path3)
          } label: {
            Text("FluidStack")
          }

          StackLink {
            BookNesting()
              .background(Color.white)
          } label: {
            Text("Nesting")
          }

          StackLink {
            BookAdditionalSafeArea()
              .background(Color.white)
          } label: {
            Text("AdditionalSafeArea")
          }

          TransitionView()
        } header: {
          Text("FluidStack")
        }

      }

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
          items.append(
            .init(
              model: .init(),
              view: .init(
                Circle()
                  .opacity(0.2)
                  .frame(width: 30, height: 30)
              )
            )
          )
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
