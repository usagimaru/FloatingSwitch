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
	@IBOutlet weak var floatingSwitch3: FloatingSwitch!
	@IBOutlet weak var interfaceStyleSwitch: FloatingSwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Switch 1
		self.floatingSwitch1.setSegments(with: [
			"Years".localized(withLanguage: "en"),
			"Months".localized(withLanguage: "en"),
			"Days".localized(withLanguage: "en"),
			"All Photos".localized(withLanguage: "en"),
		])
		self.floatingSwitch1.set(target: self, action: #selector(segmentChanged))
		
		
		// Switch 2
		self.floatingSwitch2.setSegments(with: [
			"Left".localized,
			"Center".localized,
			"Right".localized,
		])
		self.floatingSwitch2.set(target: self, action: #selector(segmentChanged))
		
		
		// Switch 3
		self.floatingSwitch3.setSegments(with: [
			"Years".localized(withLanguage: "ja"),
			"Months".localized(withLanguage: "ja"),
			"Days".localized(withLanguage: "ja"),
			"All Photos".localized(withLanguage: "ja"),
		])
		self.floatingSwitch3.set(target: self, action: #selector(segmentChanged))
		
		
		// Interface Style Switcher
		self.interfaceStyleSwitch.setSegments(with: [
			"Light".localized,
			"Dark".localized,
		])
		self.interfaceStyleSwitch.set(target: self, action: #selector(segmentChanged))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	
	// MARK: -
	
	@objc func segmentChanged(_ sender: FloatingSwitch) {
		switch sender {
		case self.floatingSwitch1:
			self.floatingSwitch3.select(segmentAt: sender.focusedIndex, animated: true)
			
		case self.floatingSwitch3:
			self.floatingSwitch1.select(segmentAt: sender.focusedIndex, animated: true)
		
		case self.floatingSwitch1, self.floatingSwitch2, self.floatingSwitch3:
			print("Selected Segment: #\(sender.focusedIndex): \(String(describing: sender.focusedSegment().title ?? ""))")
			
		case self.interfaceStyleSwitch:
			// Switch Interface Style
			self.view.window?.overrideUserInterfaceStyle = (sender.focusedIndex == 0) ? .light : .dark
			
		default:
			break
		}
	}

}

