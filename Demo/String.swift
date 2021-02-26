//
//  String.swift
//
//  Created by usagimaru on 2016.12.30.
//  Copyright © 2016 usagimaru. All rights reserved.
//

import Foundation

extension String {
	
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
	
	func localized(withLanguage lang: String? = nil) -> String {
		if let lang = lang {
			let path = Bundle.main.path(forResource: lang, ofType: "lproj")
			let bundle = Bundle(path: path!)
			return bundle?.localizedString(forKey: self, value: nil, table: nil) ?? self
		}
		else {
			return self.localized
		}
	}
	
}
