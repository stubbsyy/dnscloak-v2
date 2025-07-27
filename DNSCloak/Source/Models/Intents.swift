import Foundation
import Intents

class ToggleVPNIntent: INIntent {}

class ToggleVPNIntentResponse: INIntentResponse {
    public var code: ToggleVPNIntentResponseCode = .success

    public init(code: ToggleVPNIntentResponseCode, userActivity: NSUserActivity?) {
        self.code = code
        super.init()
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
