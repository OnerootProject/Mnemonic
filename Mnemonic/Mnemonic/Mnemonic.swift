//
//  Mnemonic.swift
//  Mnemonic
//
//  Created by 刘朋朋 on 2018/5/3.
//  Copyright © 2018年 Lone. All rights reserved.
//

import Foundation

enum MnemonicError: Error {
    case invalidArgument
    case unknownWordlist(phrase: String)
}

enum Language {
    case english
    case chinese
    
    func words() -> [String] {
        switch self {
        case .english:
            return String.englishMnemonics
        case .chinese:
            return String.chineseMnemonics
        }
    }
}

public class Mnemonic {
    private var _phrase: String
    
    private var _wordlist: [String]
    
    // data - a seed, phrase, or entropy to initialize (can be skipped)
    init(data: Any?, wordlist: [String]) throws {
        _wordlist = wordlist
        
        _phrase = ""
        
        var entropySize = 128
//        if let seed = data as? Data {
//
//        } else if let phrase = data as? String {
//
//        } else if let ent = data as? Int {
//            entropySize = ent
//        } else if let data = data {
//            throw MnemonicError.invalidArgument
//        }
        
        let count = entropySize / 8
        let bytes = Array<UInt8>(repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, UnsafeMutablePointer<UInt8>(mutating: bytes))
        if status != -1 {
            let data = Data(bytes: bytes)
//            let hexString = data.toHexString()
//            return try mnemonicString(from: hexString, language: language)
        }
    }
    
//    func isValid(mnemonic: String, wordlist: [String]) -> Bool {
//        let words = mnemonic.components(separatedBy: " ");
//        var bin = "";
//
//        for w in words {
//            var ind = wordlist.index(of: w);
//            bin = bin + ("00000000000" + ind.toString(2)).slice(-11)
//        }
//        return false
//    }
    
    func entropy2mnemonic(entropy: Data, wordlist: [String]) -> String {
        entropy.
        return ""
    }
    
    func toSeed() -> Data {
        return Data()
    }
    
    func fromSeed(seed: String, wordlist: [String]) throws -> Mnemonic {
        return try Mnemonic(data: seed, wordlist: wordlist)
    }

    func toString() -> String {
        return _phrase
    }
}
