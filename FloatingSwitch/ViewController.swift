//
//  ViewController.swift
//  FloatingSwitch
//
//  Created by usagimaru on 2019/10/12.
//  Copyright © 2019 usagimaru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var FloatingSwitch: FloatingSwitch!
	@IBOutlet weak var switchBar: FloatingSwitch!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.FloatingSwitch.setTabs(with: [
			"年別",
			"月別",
			"日別",
			"すべての写真",
		])
		self.FloatingSwitch.target = self
		self.FloatingSwitch.action = #selector(tabChanged(_:))
		
		self.switchBar.setTabs(with: [
			"Light",
			"Dark",
		])
		self.switchBar.target = self
		self.switchBar.action = #selector(tabChanged(_:))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//self.FloatingSwitch.layoutIfNeeded()
		//self.switchBar.layoutIfNeeded()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.FloatingSwitch.animateFocusMoving = true
		self.switchBar.animateFocusMoving = true
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
		case self.FloatingSwitch:
			print("Selected Index: \(sender.focusedIndex)")
			
		case self.switchBar:
			// Switch Interface Style
			self.view.window?.overrideUserInterfaceStyle = (sender.focusedIndex == 0) ? .light : .dark
			
		default:
			break
		}
	}

}

