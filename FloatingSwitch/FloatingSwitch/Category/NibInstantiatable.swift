//
//  NibInstantiatable.swift
//
//  Created by Satori Maru on 2018/11/26.
//  Copyright © 2018 usagimaru. All rights reserved.
//

import UIKit

protocol NibInstantiatable: class {

	/*
	必要なら実装クラスで以下を定義してください
	static var nibName: String {
		return "<#Nib Name#>"
	}
	*/

	/// Nib 名を返す
	static var nibName: String {get}

	static func nib(inBundle bundle: Bundle?) -> UINib
	static func fromNib<T:UIView>(inBundle bundle: Bundle?, filesOwner: Any?) -> T

}

extension NibInstantiatable {

	static var nibName: String {
		return "\(Self.self)"
	}

	static func nib(inBundle bundle: Bundle?) -> UINib {
		return UINib(nibName: self.nibName, bundle: bundle)
	}

	static func fromNib<T:UIView>(inBundle bundle: Bundle? = nil, filesOwner: Any? = nil) -> T {
		let nib = self.nib(inBundle: bundle)
		let objs = nib.instantiate(withOwner: filesOwner, options: nil)
		
		return objs.filter { $0 is UIView }.last as! T
	}

}

