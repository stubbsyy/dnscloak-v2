import UIKit
import Intents

class ToggleVPNIntent: INIntent {}

class ToggleVPNIntentResponse: INIntentResponse {
    public var code: ToggleVPNIntentResponseCode = .success

    public init(code: ToggleVPNIntentResponseCode, userActivity: NSUserActivity?) {
        self.code = code
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public enum ToggleVPNIntentResponseCode: Int {
    case unspecified
    case ready
    case continueInApp
    case inProgress
    case success
    case failure
    case failureRequiringAppLaunch
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dnsManager = DNSManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Void) {
        if let toggleVPNIntent = intent as? ToggleVPNIntent {
            dnsManager.handle(intent: toggleVPNIntent, completion: completionHandler)
        }
    }
}
