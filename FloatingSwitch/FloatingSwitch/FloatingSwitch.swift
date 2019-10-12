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
			let segmentCount = self.stackView.arrangedSubviews.count
			if focusedIndex >= segmentCount {
				focusedIndex = (segmentCount > 0) ? segmentCount - 1 : 0
			}
			
			setNeedsLayout()
		}
	}
	
	var segments: [FloatingSwitchSegment] {
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
	
	override var intrinsicContentSize: CGSize {
		// セグメントが空の時は高さを横幅に採用
		if self.segments.isEmpty {
			return CGSize(width: self.height, height: UIView.noIntrinsicMetric)
		}
		
		// スタックの最小幅＋マージン
		let width = self.stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width + self.stackView.x * 2
		return CGSize(width: width, height: UIView.noIntrinsicMetric)
	}
	
	override func prepareForInterfaceBuilder() {
		invalidateIntrinsicContentSize()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// Prepare to fix the layout first
		self.layoutIfNeeded()

		// Corner Radius of the Background View
		self.backgroundView.layer.cornerRadius = self.backgroundView.bounds.height / 2
		
		// Update Focus Layout and Appearances
		updateFocus()
	}
	
	
	// MARK: -
	
	private func updateFocus() {
		// Corner Radius of the Knob
		self.knob.layer.cornerRadius = self.backgroundView.layer.cornerRadius - (self.backgroundView.bounds.height - self.knob.bounds.height) / 2
		
		if self.focusedIndex < self.segments.count {
			let targetSegment = self.segments[self.focusedIndex]
			let targetFrame = convert(targetSegment.frame, from: targetSegment.superview)
			
			self.knob.isHidden = false
			self.knobWidthConstraint.constant = max(targetFrame.width, self.knob.height)
			self.knobXMarginConstraint.constant = targetFrame.origin.x
			
			// Animate constraints
			if self.animateFocusMoving {
				UIView.animateWithSystemMotion({
					self.backgroundView.layoutIfNeeded()
				}, completion: nil)
			}
			
			// Button Title Colors
			targetSegment.setActiveColor()
			
			for segment in self.segments where segment != targetSegment {
				segment.setInactiveColor()
			}
		}
		else {
			self.knob.isHidden = true
			self.knobWidthConstraint.constant = self.knob.height
			self.knobXMarginConstraint.constant = self.knobXMargin
		}
	}
	
	private func index(of segment: FloatingSwitchSegment) -> Int? {
		let segments = self.segments
		if segments.contains(segment) {
			return segments.firstIndex(of: segment)
		}
		return nil
	}
	
	
	// MARK: -
	
	func setSegments(with titles: [String]) {
		removeAllSegments()
		
		titles.forEach {
			let segment: FloatingSwitchSegment = FloatingSwitchSegment.fromNib()
			segment.floatingSwitch = self
			segment.title = $0
			self.stackView.addArrangedSubview(segment)
		}
		
		//setNeedsLayout()
	}
	
	func removeAllSegments() {
		self.segments.forEach {
			$0.removeFromSuperview()
		}
	}
	
	func select(segment: FloatingSwitchSegment) {
		if let segmentIndex = index(of: segment) {
			self.focusedIndex = segmentIndex
			
			if let action = self.action {
				UIApplication.shared.sendAction(action, to: self.target, from: self, for: nil)
			}
		}
	}

}
