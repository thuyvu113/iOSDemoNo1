//
//  KeychainService.swift
//  SwiftDemoProject
//
//  Created by thuyvd on 2019-02-07.
//  Copyright © 2019 Thuy Vu. All rights reserved.
//

import Foundation

class KeychainService {
  enum KeychainServiceError: Error {
    case savePasswordFailed(OSStatus)
    case getPasswordFailed(OSStatus)
    case deletePasswordFailed(OSStatus)
  }
  
  let service = "com.swiftdemoproject.password".data(using: .utf8)!
  
  func savePassword(_ password: String, forUser: String) throws {
    let account =  forUser.data(using: .utf8)!
    let passwordData = password.data(using: .utf8)!
    
    do {
      //Try to clean up
      try deletePassword(forUser: forUser)
    } catch {}
    
    let addQuery: [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: passwordData]
    
    let status = SecItemAdd(addQuery as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainServiceError.savePasswordFailed(status) }
  }
  
  func getPassword(forUser: String) throws -> String {
    let account =  forUser.data(using: .utf8)!
    let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                   kSecAttrService as String: service,
                                   kSecAttrAccount as String: account,
                                   kSecReturnData as String: true]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(getquery as CFDictionary, &item)
    guard status == errSecSuccess else { throw KeychainServiceError.getPasswordFailed(status) }
    let password = String(data: item as! Data, encoding: .utf8)!
    return password
  }
  
  func deletePassword(forUser: String) throws {
    let account =  forUser.data(using: .utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrService as String: service,
                                kSecAttrAccount as String: account]
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess else { throw KeychainServiceError.deletePasswordFailed(status) }
  }
}