import Foundation

// MARK: - UserDefault
@propertyWrapper
struct UserDefault<Value> {
    var key: String
    var defaultValue: Value
    var suiteName: String?

    var wrappedValue: Value {
        get {
            if let suiteName = suiteName {
                return UserDefaults(suiteName: suiteName)?.object(forKey: key) as? Value ?? defaultValue
            } else {
                return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
            }
        }

        set {
            if let suiteName = suiteName {
                UserDefaults(suiteName: suiteName)?.setValue(newValue, forKey: key)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: key)
            }
        }
    }

    init(key: String, defaultValue: Value, suiteName: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.suiteName = suiteName
    }

    var projectedValue: Self {
        self
    }

    func removeObject() {
        if let suiteName = suiteName {
            UserDefaults(suiteName: suiteName)?.removeObject(forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}

// MARK: - UserDefaultEncoded
@propertyWrapper
struct UserDefaultEncoded<T: Codable> {
    let key: String
    let defaultValue: T
    var suiteName: String?

    init(key: String, defaultValue: T, suiteName: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.suiteName = suiteName
    }

    var wrappedValue: T {
        get {
            guard let jsonString = (suiteName != nil ? UserDefaults(suiteName: suiteName!)! : UserDefaults.standard).string(forKey: key) else {
                return defaultValue
            }
            guard let jsonData = jsonString.data(using: .utf8) else {
                return defaultValue
            }
            guard let value = try? JSONDecoder().decode(T.self, from: jsonData) else {
                return defaultValue
            }
            return value
        }
        set {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            guard let jsonData = try? encoder.encode(newValue) else {
                return
            }
            let jsonString = String(bytes: jsonData, encoding: .utf8)
            if let suiteName = suiteName {
                UserDefaults(suiteName: suiteName)?.set(jsonString, forKey: key)
            } else {
                UserDefaults.standard.set(jsonString, forKey: key)
            }
        }
    }

    var projectedValue: Self {
        self
    }

    func removeObject() {
        if let suiteName = suiteName {
            UserDefaults(suiteName: suiteName)?.removeObject(forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}

// MARK: Example Models
struct UserModel: Codable {
    var name: String
    var age: Int
}

struct NetflixModel: Codable {
    var movieName: String
    var ratings: Int
}

// MARK: - UserDefaults
extension UserDefaults {
    @UserDefault(key: "isOnboarded", defaultValue: false) static var isOnboarded: Bool
    @UserDefault(key: "isDay", defaultValue: false, suiteName: "your suite name for example: group.com.demoApp.widgetExtension") static var isDay: Bool
    @UserDefault(key: "tapCount", defaultValue: 0) static var tapCount: Int
    @UserDefault(key: "appLanguage", defaultValue: "en") static var appLanguage: String
    @UserDefault(key: "savedBookmarks", defaultValue: []) static var savedBookmarks: [String]
    
    @UserDefaultEncoded(key: "userModel", defaultValue: UserModel(name: "Jash", age: 1)) static var userModel: UserModel
    @UserDefaultEncoded(key: "netflixModel", defaultValue: NetflixModel(movieName: "Once upon a time in Hollywood", ratings: 10)) static var netflixModel: NetflixModel
}
