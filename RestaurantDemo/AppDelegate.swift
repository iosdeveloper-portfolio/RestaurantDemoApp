
import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let shared = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?
    var currentStoreLocation = CLLocationCoordinate2D()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(Constant.kGoogleDirectionAPI)
        GMSPlacesClient.provideAPIKey(Constant.kGoogleDirectionAPI)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

