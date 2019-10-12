//
//  FloatingSwitch.swift
//  FloatingSwitch
//
//  Created by usagimaru on 2019/10/12.
//  Copyright © 2019 usagimaru. All rights reserved.
//

import UIKit

class FloatingSwitch: UIView, NibInstantiatable {

	@IBOutlet private weak var stackView: UIStackView!
	@IBOutlet private weak var backgroundView: UIVisualEffectView!
	@IBOutlet private weak var knob: UIView!
	@IBOutlet private weak var knobXMarginConstraint: NSLayoutConstraint!
	@IBOutlet private weak var knobWidthConstraint: NSLayoutConstraint!
	
	private var knobXMargin: CGFloat = 0
	
	weak var target: NSObject?
	var action: Selector?
	
	var animateFocusMoving: Bool = false
	var focusedIndex: Int = 0 {
		didSet {
			let tabCount = self.stackView.arrangedSubviews.count
			if focusedIndex >= tabCount {
				focusedIndex = (tabCount > 0) ? tabCount - 1 : 0
			}
			
			setNeedsLayout()
		}
	}
	
	var tabs: [FloatingSwitchSegment] {
		return self.stackView.arrangedSubviews as? [FloatingSwitchSegment] ?? []
	}
	
	
	// MARK: -
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		_init()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		_init()
	}
	
	private func _init() {
		loadNib()
	}
	
	private func loadNib() {
		let view = FloatingSwitch.fromNib(inBundle: nil, filesOwner: self)
		addSubview(view)
		
		view.translatesAutoresizingMaskIntoConstraints = false
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
													  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
													  metrics: nil,
													  views: ["view" : view]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
													  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
													  metrics: nil,
													  views: ["view" : view]))
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.backgroundView.layer.cornerCurve = .continuous
		self.backgroundView.clipsToBounds = true
		self.knob.layer.cornerCurve = .continuous
		self.knob.clipsToBounds = true
		
		self.knobXMargin = self.knobXMarginConstraint.constant
		
		setNeedsLayout()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		// Corner Radius of the Background View
		self.backgroundView.layer.cornerRadius = self.backgroundView.bounds.height / 2
		
		// Update Focus Layout and Appearances
		updateFocus()
	}
	
	
	// MARK: -
	
	private func updateFocus() {
		// Corner Radius of the Knob
		self.knob.layer.cornerRadius = self.backgroundView.layer.cornerRadius - (self.backgroundView.bounds.height - self.knob.bounds.height) / 2

		// Prepare to fix the layout first
		self.layoutIfNeeded()
		
		if self.focusedIndex < self.tabs.count {
			let targetTab = self.tabs[self.focusedIndex]
			
			self.knob.isHidden = false
			self.knobWidthConstraint.constant = max(targetTab.width - self.knobXMargin * 2, self.knob.height)
			self.knobXMarginConstraint.constant = targetTab.x + self.knobXMargin
			
			// Animate constraints
			if self.animateFocusMoving {
				UIView.animateWithSystemMotion({
					self.backgroundView.layoutIfNeeded()
				}, completion: nil)
			}
			
			// Button Title Colors
			targetTab.setActiveColor()
			
			for tab in self.tabs where tab != targetTab {
				tab.setInactiveColor()
			}
		}
		else {
			self.knob.isHidden = true
			self.knobWidthConstraint.constant = self.knob.height
			self.knobXMarginConstraint.constant = self.knobXMargin
		}
	}
	
	private func index(of tab: FloatingSwitchSegment) -> Int? {
		let tabs = self.tabs
		if tabs.contains(tab) {
			return tabs.firstIndex(of: tab)
		}
		return nil
	}
	
	
	// MARK: -
	
	func setTabs(with titles: [String]) {
		removeAllTabs()
		
		titles.forEach {
			let tab: FloatingSwitchSegment = FloatingSwitchSegment.fromNib()
			tab.tabBar = self
			tab.title = $0
			self.stackView.addArrangedSubview(tab)
		}
		
		//setNeedsLayout()
	}
	
	func removeAllTabs() {
		self.tabs.forEach {
			$0.removeFromSuperview()
		}
	}
	
	func select(tab: FloatingSwitchSegment) {
		if let tabIndex = index(of: tab) {
			self.focusedIndex = tabIndex
			
			if let action = self.action {
				UIApplication.shared.sendAction(action, to: self.target, from: self, for: nil)
			}
		}
	}

}
