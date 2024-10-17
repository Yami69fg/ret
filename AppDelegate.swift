import UIKit
import AVFoundation
import AppsFlyerLib
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.allOrientationStatus
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
    
    public var interfaceMaskForOnFrenzyGameField: UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppsFlyerLib.shared().appsFlyerDevKey = "ECQCmczrGzgFKbgCHTjWqG"
        AppsFlyerLib.shared().appleAppID = "6736921573"
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 6)
      
       
        return true
    }
    
    static var allOrientationStatus = UIInterfaceOrientationMask.all
    

  

    
}


