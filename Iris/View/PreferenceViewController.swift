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
	@IBOutlet weak var colorPicker: NSColorWell!
	
	private var debounce = false
	private var config: UserSetting = UserSetting()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		endpointTextField.delegate = self
		ledCountTextField.delegate = self
		
		endpointTextField.stringValue = config.getEndpoint()
		ledCountTextField.stringValue = String(config.getLedCount())
	}
	
	override func viewWillDisappear() {
		super.viewWillDisappear()
		NotificationCenter.default.post(name: NSNotification.Name("configClosed"), object: nil)
	}
	
}

extension PreferenceViewController: NSTextFieldDelegate {
	func controlTextDidChange(_ notification: Notification) {
		if let textField = notification.object as? NSTextField {
			switch textField {
			case endpointTextField:
				if(!textField.stringValue.isValidURL()) {
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
			default:
				print("nothing")
			}
		}
	}
}


