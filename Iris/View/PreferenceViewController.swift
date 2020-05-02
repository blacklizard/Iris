//
//  PreferenceViewController.swift
//  Iris
//
//  Created by blacklizard on 19/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Cocoa

class PreferenceViewController: NSViewController {
	
	@IBOutlet weak var endpointTextField: NSTextField!
	@IBOutlet weak var ledCountTextField: NSTextField!
	@IBOutlet weak var ledDirection: NSPopUpButton!
	@IBOutlet weak var staticColor: NSButton!
	
	private var colorSelectionThrottler = Throttler(minimumDelay: 0.009)
	private var config: UserSetting = UserSetting()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		endpointTextField.delegate = self
		ledCountTextField.delegate = self
		
		endpointTextField.stringValue = config.getEndpoint() ?? ""
		ledCountTextField.stringValue = String(config.getLedCount())
		
		ledDirection.selectItem(withTag: Int(config.getLedDirection())!)
		
		staticColor.state = config.getIsStaticMode() == true ? .on : .off
	}
	
	override func viewWillDisappear() {
		super.viewWillDisappear()
		NotificationCenter.default.post(name: NSNotification.Name("configDidClose"), object: nil)
	}
	@IBAction func colorChanged(_ sender: NSColorWell) {
		colorSelectionThrottler.throttle {
			self.config.setStaticColor(color: sender.color.toHexBytes)
		}
	}
	
	@IBAction func modeChanged(_ sender: NSButton) {
		switch sender.state {
			case .on:
				config.setStaticMode(is_static: true)
			case .off:
				config.setStaticMode(is_static: false)
			default: break
		}
	}
	
	@IBAction func ledDirectionChanged(_ sender: NSPopUpButton) {
		let direction = sender.selectedItem!.identifier!.rawValue as String
		config.setLedDirection(direction: direction)
	}
}

extension PreferenceViewController: NSTextFieldDelegate {
	func controlTextDidChange(_ notification: Notification) {
		if let textField = notification.object as? NSTextField {
			switch textField {
			case endpointTextField:
				if(!textField.stringValue.isValidIPv4()) {
					textField.backgroundColor = .red
				} else {
					textField.backgroundColor = .none
					config.setEndpoint(endpoint: textField.stringValue)
				}
			case ledCountTextField:
				if(!textField.stringValue.isValidNumber()) {
					textField.backgroundColor = .red
				} else {
					textField.backgroundColor = .none
					config.setLedCount(count: Int(textField.stringValue)!)
				}
			default: break
			}
		}
	}
}


