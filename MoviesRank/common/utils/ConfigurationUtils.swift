//
//  ConfigurationUtils.swift
//  MoviesRank
//
//  Created by Carlos Vázquez Gómez on 4/2/19.
//  Copyright © 2019 Carlos Vázquez Gómez. All rights reserved.
//

import Foundation

struct ConfigurationUtils {
    
    enum DictionaryKey: String {
        case tracktBaseUrl
        case tracktAPIkey
        case tracktVersionAPI
        case moviedbBaseUrl
        case moviedbAPIkey
        case moviedbVersionAPI
        
        static func value(_ key: DictionaryKey) -> String {
            return key.rawValue
        }
    }
    
    fileprivate static var infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist cannot be found")
        }
        return dictionary
    }()
    
    public static func valueFromDictionary(_ key: DictionaryKey) -> String {
        return infoDictionary[DictionaryKey.value(key)] as! String
    }
}
