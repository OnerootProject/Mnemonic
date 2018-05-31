//
//  Mnemonic.swift
//  Mnemonic
//
//  Created by 刘朋朋 on 2018/5/3.
//  Copyright © 2018年 Lone. All rights reserved.
//

import Foundation
import CryptoSwift

enum MnemonicError: Error {
    case invalidArgument
    case invalidEntropy
    case unknownWordlist(phrase: String)
    case unexpected
}

public enum Language {
    case english
    case chinese
    
    var words: [String] {
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
    
    public init(language: Language = .english) {
        _wordlist = language.words
        
        _phrase = ""
        _phrase = mnemonic(ENT: 128, wordlist: _wordlist)
    }
    
    public init(phrase: String, language: Language = .english) {
        _wordlist = language.words
        
        _phrase = phrase
    }
    
    private func mnemonic(ENT: Int, wordlist: [String]) -> String {
        guard ENT % 32 == 0 else {
            return ""
        }
        
        let count = ENT / 8
        let bytes = Array<UInt8>(repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, UnsafeMutablePointer<UInt8>(mutating: bytes))
        // print(status)
        if status != -1 {
            let data = Data(bytes: bytes)
            let hexString = data.toHexString()
            
            return mnemonicString(from: hexString, wordlist: wordlist)
        }
        
        return ""
    }
    
    private func mnemonicString(from hexString: String, wordlist: [String]) -> String {
        let seedData = hexString.ck_mnemonicData()
        
        let hashData = seedData.sha256()
        
        let checkSum = hashData.ck_toBitArray()
        
        var seedBits = seedData.ck_toBitArray()
        
        for i in 0..<seedBits.count / 32 {
            seedBits.append(checkSum[i])
        }
        
        let words = wordlist
        
        let mnemonicCount = seedBits.count / 11
        var mnemonic = [String]()
        for i in 0..<mnemonicCount {
            let length = 11
            let startIndex = i * length
            let subArray = seedBits[startIndex..<startIndex + length]
            let subString = subArray.joined(separator: "")
            // print(subString)
            
            let index = Int(strtoul(subString, nil, 2))
            mnemonic.append(words[index])
        }
        return mnemonic.joined(separator: " ")
    }
    
    public func toSeed(passphrase: String = "") throws -> String {
        func normalized(string: String) -> Data? {
            guard let data = string.data(using: .utf8, allowLossyConversion: true) else {
                return nil
            }
            
            guard let dataString = String(data: data, encoding: .utf8) else {
                return nil
            }
            
            guard let normalizedData = dataString.data(using: .utf8, allowLossyConversion: false) else {
                return nil
            }
            return normalizedData
        }
        
        guard let normalizedData = normalized(string: _phrase) else {
            return ""
        }
        
        guard let saltData = normalized(string: "mnemonic" + passphrase) else {
            return ""
        }
        
        let password = normalizedData.bytes
        let salt = saltData.bytes
        
        do {
            let bytes = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 2048, variant: .sha512).calculate()
            
            return bytes.toHexString()
        } catch {
            // print(error)
            throw error
        }
    }
    
    public func toString() -> String {
        return _phrase
    }
}
