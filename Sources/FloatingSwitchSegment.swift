//
//  FloatingSwitchSegment.swift
//  FloatingSwitch
//
//  Created by usagimaru on 2019/10/12.
//  Copyright © 2019 usagimaru. All rights reserved.
//

import UIKit

class FloatingSwitchSegment: UIView {

	@IBOutlet weak var button: UIButton!
	
	var title: String? {
		get {
			return self.button.currentTitle
		}
		set {
			self.button.setTitle(newValue, for: .normal)
		}
	}
	
	var animatesTitleColor: Bool = true
	
	var titleColor: UIColor? {
		get {
			return self.button.titleColor(for: .normal)
		}
		set {
			UIView.transition(with: self.button,
							  duration: self.animatesTitleColor ? 0.25 : 0.0,
							  options: .transitionCrossDissolve,
							  animations: {
								self.button.setTitleColor(newValue, for: .normal)
			},
							  completion: nil)
		}
	}
	
	weak var floatingSwitchView: FloatingSwitchView?
	
	private var isNibLoaded = false
	
	var contentInsets: UIEdgeInsets {
		get {
			return self.button.contentEdgeInsets
		}
		set {
			self.button.contentEdgeInsets = newValue
		}
	}
	
	
	// MARK: -
	
	required convenience init() {
		self.init(frame: .zero)
		loadNib()
	}
	
	private func loadNib() {
		defer {
			self.isNibLoaded = true
		}
		if self.isNibLoaded {
			return
		}
		
		#if SWIFT_PACKAGE && swift(>=5.3)
		let bundle = Bundle.module
		#else
		let bundle = Bundle(for: type(of: self))
		#endif
		
		let nib = UINib(nibName: "\(Self.self)", bundle: bundle)
		let objs = nib.instantiate(withOwner: self, options: nil)
		
		guard let contentView = objs.first as? UIView else {
			fatalError("Initializing error")
		}
		
		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|",
													  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
													  metrics: nil,
													  views: ["contentView" : contentView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|",
													  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
													  metrics: nil,
													  views: ["contentView" : contentView]))
		
		self.contentInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		loadNib()
	}
	
	@IBAction func tapped(_ sender: UIButton) {
		self.floatingSwitchView?.select(segment: self, animated: true, sendsAction: true)
	}
	
	func setActiveColor() {
		self.titleColor = UIColor.white
	}
	
	func setInactiveColor() {
		self.titleColor = UIColor.secondaryLabel
	}
	
}
