
import Foundation

class FavoritesRepository {
    
    private let persistedFavorites = BoolUserDefaults.shared

    func setFavorite(for key: Int) {
        persistedFavorites.setBool(value: true, forKey: key)
    }
    
    func isFavorite(for key: Int) -> Bool {
        return persistedFavorites.bool(forKey: key)
    }
}

class BoolUserDefaults {
    private let userDefaults: UserDefaults = .standard

    static let shared = BoolUserDefaults()
    
    private init () {}

    func setBool(value: Bool, forKey key: Int) {
        userDefaults.set(value, forKey: String(key))
    }

    func bool(forKey key: Int) -> Bool {
        return userDefaults.bool(forKey: String(key))
    }

    func removeValue(forKey key: Int) {
        userDefaults.removeObject(forKey: String(key))
    }
}
