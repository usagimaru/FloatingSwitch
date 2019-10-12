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
	
}
