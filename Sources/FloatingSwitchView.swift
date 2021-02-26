//
//  FloatingSwitchView.swift
//  FloatingSwitch
//
//  Created by usagimaru on 2019/10/12.
//  Copyright © 2019 usagimaru. All rights reserved.
//

import UIKit

public class FloatingSwitchView: UIView {

	@IBOutlet private weak var stackView: UIStackView!
	@IBOutlet private weak var backgroundView: UIVisualEffectView!
	@IBOutlet private weak var knob: UIView!
	@IBOutlet private weak var knobXMarginConstraint: NSLayoutConstraint!
	@IBOutlet private weak var knobWidthConstraint: NSLayoutConstraint!
	
	private var knobXMargin: CGFloat = 0
	private var isNibLoaded = false
	
	public weak var target: NSObject?
	public var action: Selector?
	
	public var animatesFocusMoving: Bool = true
	private var animatesFocusMoving_internal: Bool = false
	
	public var focusedIndex: Int = 0 {
		didSet {
			let segmentCount = self.stackView.arrangedSubviews.count
			if focusedIndex >= segmentCount {
				focusedIndex = (segmentCount > 0) ? segmentCount - 1 : 0
			}
			
			setNeedsLayout()
		}
	}
	
	public var segments: [FloatingSwitchSegment] {
		return self.stackView.arrangedSubviews as? [FloatingSwitchSegment] ?? []
	}
	
	public override var intrinsicContentSize: CGSize {
		// セグメントが空の時は高さを横幅に採用
		if self.segments.isEmpty {
			return CGSize(width: self.frame.height, height: UIView.noIntrinsicMetric)
		}
		
		// スタックの最小幅＋マージン
		let width = self.stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width + self.stackView.frame.minX * 2
		return CGSize(width: width, height: UIView.noIntrinsicMetric)
	}
	
	
	// MARK: -
	
	public convenience init() {
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
		
		self.backgroundView.layer.cornerCurve = .continuous
		self.backgroundView.clipsToBounds = true
		self.knob.layer.cornerCurve = .continuous
		self.knob.clipsToBounds = true
		
		self.knobXMargin = self.knobXMarginConstraint.constant
		
		setNeedsLayout()
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		loadNib()
	}
	
	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		loadNib()
		invalidateIntrinsicContentSize()
	}
	
	public override func didMoveToSuperview() {
		//self.animatesFocusMoving_internal = true
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		// Prepare to fix the layout first.
		self.layoutIfNeeded()

		// Corner Radius of the Background View.
		self.backgroundView.layer.cornerRadius = self.backgroundView.bounds.height / 2
		
		// Update Focus Layout and Appearances.
		updateFocus()
		
		// Disable the focus animation for the first time only.
		self.animatesFocusMoving_internal = true
	}
	
	
	// MARK: -
	
	private func updateFocus() {
		// Corner Radius of the Knob
		self.knob.layer.cornerRadius = self.backgroundView.layer.cornerRadius - (self.backgroundView.bounds.height - self.knob.bounds.height) / 2
		
		if self.focusedIndex < self.segments.count {
			let targetSegment = self.segments[self.focusedIndex]
			let targetFrame = convert(targetSegment.frame, from: targetSegment.superview)
			
			self.knob.isHidden = false
			self.knobWidthConstraint.constant = max(targetFrame.width, self.knob.frame.height)
			self.knobXMarginConstraint.constant = targetFrame.origin.x
			
			// Animate constraints
			if self.animatesFocusMoving && self.animatesFocusMoving_internal {
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
			self.knobWidthConstraint.constant = self.knob.frame.height
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
	
	public func set(target: NSObject?, action: Selector) {
		self.target = target
		self.action = action
	}
	
	
	// MARK: -
	
	public func setSegments(with titles: [String]) {
		removeAllSegments()
		
		titles.forEach {
			let segment = FloatingSwitchSegment()
			self.stackView.addArrangedSubview(segment)
			segment.floatingSwitchView = self
			segment.title = $0
		}
		
		//setNeedsLayout()
	}
	
	public func removeAllSegments() {
		self.segments.forEach {
			$0.removeFromSuperview()
		}
	}
	
	public func select(segment: FloatingSwitchSegment, animated: Bool, sendsAction: Bool = false) {
		if let segmentIndex = index(of: segment) {
			self.animatesFocusMoving_internal = animated
			self.focusedIndex = segmentIndex
			
			if let action = self.action, sendsAction {
				UIApplication.shared.sendAction(action, to: self.target, from: self, for: nil)
			}
		}
	}
	
	public func select(segmentAt index: Int, animated: Bool, sendsAction: Bool = false) {
		if index < self.segments.count {
			self.animatesFocusMoving_internal = animated
			self.focusedIndex = index
			
			if let action = self.action, sendsAction {
				UIApplication.shared.sendAction(action, to: self.target, from: self, for: nil)
			}
		}
	}
	
	public func focusedSegment() -> FloatingSwitchSegment {
		return self.segments[self.focusedIndex]
	}

}

extension UIView {
	
	/// iOSの標準的な動きを再現します
	class func animateWithSystemMotion(_ animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
		UIView.perform(.delete,
					   on: [],
					   options: [.beginFromCurrentState, .allowUserInteraction],
					   animations: animations,
					   completion: completion)
	}
	
}
