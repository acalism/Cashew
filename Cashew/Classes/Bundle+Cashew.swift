//
//  Bundle+Cashew.swift
//  Cashew
//
//  Created by acalism@gmail.com on 12/02/2019.
//  Copyright (c) 2019 acalism@gmail.com. All rights reserved.

import Foundation

private var languageKey: UInt8 = 0

class CashewBundleEx: Bundle
{
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String
    {
        guard let bundle = objc_getAssociatedObject(self, &languageKey) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        let str: String = bundle.localizedString(forKey: key, value: value, table: tableName)
        return str
    }
}


public extension Bundle
{
    static func changeMainBundleType()
    {
        object_setClass(Bundle.main, CashewBundleEx.self)
    }

    static var cashew_language: String? {
        get {
            changeMainBundleType()
            guard let preferredLanguages = UserDefaults.standard.object(forKey:"AppleLanguages") as? [String] else { return nil }
            return preferredLanguages.first
        }
        set {
            changeMainBundleType()
            let set = CharacterSet(charactersIn: "-_")
            var lang = newValue
            var langBundlePath: String? = nil
            var bundle: Bundle? = nil
            while langBundlePath == nil {
                langBundlePath = Bundle.main.path(forResource: lang, ofType: "lproj")
                guard let range = lang?.rangeOfCharacter(from: set, options: .backwards, range: nil),
                    let l = lang?.prefix(upTo: range.lowerBound)
                else {
                    break
                }
                lang = String(l)
            }
            if let path = langBundlePath {
                bundle = Bundle(path: path)
            }
            objc_setAssociatedObject(Bundle.main, &languageKey, bundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            checkLanguage(newValue)
        }
    }

    static func checkLanguage(_ lang: String?)
    {
        let ud = UserDefaults.standard
        if let oldLang = Bundle.cashew_language {
            print("oldLang = \(oldLang)")
        }
        print("Before:")
        print("Locale.availableIdentifiers = \(Locale.availableIdentifiers)")
        print("Locale.preferredLanguages = \(Locale.preferredLanguages)")
        print("UserDefaults = \(ud.dictionaryRepresentation())")

        guard var langs = ud.object(forKey: "AppleLanuages") as? [String] else { return }
        guard let lang = lang, lang.count > 0 && langs.count > 0 else {
            return
        }
        var needsToInsert = false
        if let index = langs.firstIndex(of: lang) {
            if index != 0 {
                langs.remove(at: index)
                needsToInsert = true
            }
        } else {
            needsToInsert = true
        }

        if needsToInsert {
            langs.insert(lang, at: 0)
            ud.set(langs, forKey: "AppleLanguages")
            ud.set(langs, forKey: "NSLanguages")
            ud.set(0, forKey: "PreferredLanguages")

            print("After:")
            print("Locale.preferredLanguages = \(Locale.preferredLanguages)")
            print("UserDefaults = \(ud.dictionaryRepresentation())")
        }
    }
}
