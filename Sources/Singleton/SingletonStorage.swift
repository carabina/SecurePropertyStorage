import CryptoKit
import Foundation
import Keychain
import Storage

open class SingletonStorage: DelegatedStorage {
    open class var standard: DelegatedStorage { shared }
    private static let shared = SingletonStorage()

    public convenience init(_ delegate: StorageDelegate = SingletonStorageDelegate(),
                            authenticationTag: Data? = nil) {
        self.init(delegate,
                  symmetricKey: SymmetricKey.generate(),
                  nonce: AES.GCM.Nonce.generate(),
                  authenticationTag: authenticationTag)
    }
}

open class SingletonStorageDelegate: StorageDelegate {
    private var shared = [AnyHashable: Any]()

    public init() {}

    open func data<D: StorageData>(forKey key: String) throws -> D? { shared[key] as? D }

    open func set<D: StorageData>(_ data: D?, forKey key: String) throws { shared[key] = data }

    open func remove(forKey key: String) throws { shared.removeValue(forKey: key) }
}
