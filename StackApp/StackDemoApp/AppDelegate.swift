
import UIKit
@_exported import SwiftUI

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
  
  public var window: UIWindow?
  
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    let window = UIWindow()
    window.rootViewController = UIHostingController(rootView: ContentView())
    self.window = window
    window.makeKeyAndVisible()
        
    return true
  }
  
}
