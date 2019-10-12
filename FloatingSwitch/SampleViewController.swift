//
//  SampleViewController.swift
//  FloatingSwitch
//
//  Created by usagimaru on 2019/10/12.
//  Copyright © 2019 usagimaru. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

	@IBOutlet weak var floatingSwitch1: FloatingSwitch!
	@IBOutlet weak var floatingSwitch2: FloatingSwitch!
	@IBOutlet weak var interfaceStyleSwitch: FloatingSwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Switch 1
		self.floatingSwitch1.setTabs(with: [
			"Years".localized,
			"Months".localized,
			"Days".localized,
			"All Photos".localized,
		])
		self.floatingSwitch1.target = self
		self.floatingSwitch1.action = #selector(tabChanged(_:))
		
		
		// Switch 2
		self.floatingSwitch2.setTabs(with: [
			"Left".localized,
			"Center".localized,
			"Right".localized,
		])
		self.floatingSwitch2.target = self
		self.floatingSwitch2.action = #selector(tabChanged(_:))
		
		
		// Switch 3: Interface Style Switcher
		self.interfaceStyleSwitch.setTabs(with: [
			"Light".localized,
			"Dark".localized,
		])
		self.interfaceStyleSwitch.target = self
		self.interfaceStyleSwitch.action = #selector(tabChanged(_:))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.floatingSwitch1.animateFocusMoving = true
		self.floatingSwitch2.animateFocusMoving = true
		self.interfaceStyleSwitch.animateFocusMoving = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	
	// MARK: -
	
	@objc func tabChanged(_ sender: FloatingSwitch) {
		switch sender {
		case self.floatingSwitch1, self.floatingSwitch2:
			print("Selected Index: \(sender.focusedIndex)")
			
		case self.interfaceStyleSwitch:
			// Switch Interface Style
			self.view.window?.overrideUserInterfaceStyle = (sender.focusedIndex == 0) ? .light : .dark
			
		default:
			break
		}
	}

}

