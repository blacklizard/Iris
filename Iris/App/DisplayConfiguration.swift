//
//  DisplayConfiguration.swift
//  Iris
//
//  Created by blacklizard on 19/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Foundation

class DisplayConfiguration {
	
	var displayConfigurationDelagate: DisplayConfigurationDelegate!
	
	static let displayReconfigurationCallBack: CGDisplayReconfigurationCallBack = { (displayId, flags, this) in
		guard let opaque = this else {
			return
		}
		
		let displayConfiguration = Unmanaged<DisplayConfiguration>.fromOpaque(opaque).takeUnretainedValue()
		if (!flags.contains(.beginConfigurationFlag)) {
			displayConfiguration.configurationDidChange()
		}
	}
	
	init() {
		attachDisplayConfigurationChangedCallback()
	}
	
	deinit {
		detachDisplayConfigurationChangedCallback()
	}
	
	func getMainDisplay() -> UInt32 {
		return CGMainDisplayID()
	}
	
	private func attachDisplayConfigurationChangedCallback() {
		let displayConfiguration = Unmanaged<DisplayConfiguration>.passUnretained(self).toOpaque()
		CGDisplayRegisterReconfigurationCallback(DisplayConfiguration.displayReconfigurationCallBack, displayConfiguration)
	}
	
	private func detachDisplayConfigurationChangedCallback() {
		let displayConfiguration = Unmanaged<DisplayConfiguration>.passUnretained(self).toOpaque()
		CGDisplayRemoveReconfigurationCallback(DisplayConfiguration.displayReconfigurationCallBack, displayConfiguration)
	}
	
	private func configurationDidChange() {
		displayConfigurationDelagate.displayConfigurationOnChange()
	}
}
