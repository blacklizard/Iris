//
//  AppDelegate.swift
//  Iris
//
//  Created by blacklizard on 19/04/2020.
//  Copyright © 2020 blacklizard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	private var preferenceWindowController: NSWindowController?
	private var screenGrabber:ScreenGrabber?
	private let reachability:Reachability = Reachability()
	private let device: Device = Device()
	private var config = UserSetting()
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	private var timeoutCount: Int = 0
	var reachablityTimer: Timer!
	
	@IBOutlet weak var statusMenu: NSMenu!
	@IBOutlet weak var toggleMenuItem: NSMenuItem!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		attachStatusMenu()
		registerObserver()
		
		screenGrabber = ScreenGrabber()
		screenGrabber?.screenGrabberDelegate = self
		screenGrabber?.setLedCount(count: config.getLedCount())
		
		reachability.reachabilityDelegate = self
		device.setEndpoint(endpoint: config.getEndpoint())
		
		if(device.isReachable()) {
			toggleMenuItem.title = "Pause"
			screenGrabber?.start()
		}
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	@IBAction func toggleState(_ sender: Any) {
		toggleStateItem()
	}
	
	@IBAction func showPreference(_ sender: NSMenuItem) {
		screenGrabber?.stop()
		if preferenceWindowController == nil {
			preferenceWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PreferenceWindowController") as? NSWindowController
		}
		NSApp.activate(ignoringOtherApps: true)
		preferenceWindowController?.showWindow(self)
		preferenceWindowController?.window?.makeKey()
	}
	
	private func toggleStateItem() {
		if(toggleMenuItem.title == "Resume") {
			screenGrabber?.start()
			toggleMenuItem.title = "Pause"
		} else {
			screenGrabber?.stop()
			toggleMenuItem.title = "Resume"
		}
	}
	
	private func attachStatusMenu() {
		statusItem.menu = statusMenu
		let icon = NSImage(named: "statusBarIcon")
		icon?.isTemplate = true // best for dark mode
		statusItem.button?.image = icon
		statusItem.menu = statusMenu
	}
	
	private func registerObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(endpointDidUpdate(notification:)), name: NSNotification.Name("endpoint"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ledCountDidUpdate(notification:)), name: NSNotification.Name("ledCount"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(resumeScreenGrabber(notification:)), name: NSNotification.Name("configClosed"), object: nil)
	}
	
	@objc func resumeScreenGrabber(notification: NSNotification) {
		screenGrabber?.start()
	}
	
	@objc func endpointDidUpdate(notification: NSNotification) {
		device.setEndpoint(endpoint:  config.getEndpoint())
	}
	
	@objc func ledCountDidUpdate(notification: NSNotification) {
		screenGrabber?.setLedCount(count: config.getLedCount())
	}
}

extension AppDelegate: ScreenGrabberDelegate {
	func dataDidUpdated(data: String) {
		let errored = device.send(data: data)
		if errored {
			timeoutCount += 1
			if timeoutCount >= 3{
				screenGrabber?.stop()
				reachability.start(device: device)
			}
		}
	}
}

extension AppDelegate: ReachabilityDelegate {
	func deviceDidBecomeOnline() {
		screenGrabber?.start()
	}
}



