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
		self.floatingSwitch1.setSegments(with: [
			"Years".localized,
			"Months".localized,
			"Days".localized,
			"All Photos".localized,
		])
		self.floatingSwitch1.target = self
		self.floatingSwitch1.action = #selector(segmentChanged)
		
		
		// Switch 2
		self.floatingSwitch2.setSegments(with: [
			"Left".localized,
			"Center".localized,
			"Right".localized,
		])
		self.floatingSwitch2.target = self
		self.floatingSwitch2.action = #selector(segmentChanged)
		
		
		// Switch 3: Interface Style Switcher
		self.interfaceStyleSwitch.setSegments(with: [
			"Light".localized,
			"Dark".localized,
		])
		self.interfaceStyleSwitch.target = self
		self.interfaceStyleSwitch.action = #selector(segmentChanged)
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
	
	
	// MARK: -
	
	@objc func segmentChanged(_ sender: FloatingSwitch) {
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

