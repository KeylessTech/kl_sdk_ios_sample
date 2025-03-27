import Foundation

enum Configuration{
    
    private static let infoDict : [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist not found")
        }
        return dict
    }()
    
    static let apiKey : String = {
        guard let apiKeyString = Configuration.infoDict["API_KEY"] as? String else {
            fatalError("cannot find API_KEY in plist")
        }
        return apiKeyString
    }()
    
    static let host : String = {
        guard let host = Configuration.infoDict["HOST"] as? String else {
            fatalError("cannot find HOST in plist")
        }
        return host
    }()
}
