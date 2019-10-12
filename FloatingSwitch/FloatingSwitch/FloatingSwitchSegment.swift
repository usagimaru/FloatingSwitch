//
//  FloatingSwitchSegment.swift
//  FloatingSwitch
//
//  Created by usagimaru on 2019/10/12.
//  Copyright © 2019 usagimaru. All rights reserved.
//

import UIKit

class FloatingSwitchSegment: UIView, NibInstantiatable {

	@IBOutlet weak var button: UIButton!
	var title: String? {
		get {
			return self.button.currentTitle
		}
		set {
			self.button.setTitle(newValue, for: .normal)
		}
	}
	
	var animateTitleColor: Bool = true
	
	var titleColor: UIColor? {
		get {
			return self.button.titleColor(for: .normal)
		}
		set {
			UIView.transition(with: self.button,
							  duration: self.animateTitleColor ? 0.25 : 0.0,
							  options: .transitionCrossDissolve,
							  animations: {
								self.button.setTitleColor(newValue, for: .normal)
			},
							  completion: nil)
		}
	}
	
	weak var tabBar: FloatingSwitch?
	
	@IBAction func tapped(_ sender: UIButton) {
		self.tabBar?.select(tab: self)
	}
	
	func setActiveColor() {
		self.titleColor = UIColor.white
	}
	
	func setInactiveColor() {
		self.titleColor = UIColor.secondaryLabel
	}
	
}
