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
		
		reachability.reachabilityDelegate = self
		
		if(!config.isSettingComplete()) {
			showPreference()
		} else {
			updateSetting()
			if(device.isReachable()) {
				startStrip()
            } else {
                reachability.start(device: device)
            }
		}
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
        print("applicationWillTerminate")
        stopStrip()
		detachObserver()
	}
	
    private func startStrip() {
        if(config.getIsStaticMode() == true) {
            let _ = device.sendStaticColor(data: config.getColor())
        } else {
            screenGrabber?.start()
        }
    }
    
    private func stopStrip() {
        if(config.getIsStaticMode() != true) {
            screenGrabber?.stop()
        }
        
        let _ = device.sendStaticColor(data: [UInt8(0), UInt8(0), UInt8(0)])
    }
    
	@IBAction func showPreference(_ sender: NSMenuItem = NSMenuItem()) {
		screenGrabber?.stop()
		if preferenceWindowController == nil {
			preferenceWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PreferenceWindowController") as? NSWindowController
		}
		NSApp.activate(ignoringOtherApps: true)
		preferenceWindowController?.showWindow(self)
		preferenceWindowController?.window?.makeKey()
	}
	    
	private func attachStatusMenu() {
		statusItem.menu = statusMenu
		let icon = NSImage(named: "statusBarIcon")
		icon?.isTemplate = true // best for dark mode
		statusItem.button?.image = icon
		statusItem.menu = statusMenu
	}
	
	private func detachObserver() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("setting.update"), object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("static.did.change"), object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("configDidClose"), object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(didWakeNotification(note:)),name: NSWorkspace.didWakeNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(willSleepNotification(note:)),name: NSWorkspace.willSleepNotification, object: nil)
	}
	
	private func registerObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(updateSetting), name: NSNotification.Name("setting.update"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(staticConfigDidChange), name: NSNotification.Name("static.did.change"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(resumeScreenGrabber(notification:)), name: NSNotification.Name("configDidClose"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didWakeNotification(note:)),name: NSWorkspace.didWakeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willSleepNotification(note:)),name: NSWorkspace.willSleepNotification, object: nil)
	}
	
	@objc func staticConfigDidChange() {
		screenGrabber?.stop()
		let isEnabled  = config.getIsStaticMode()
		var color:[UInt8]!
		if(isEnabled) {
			color = config.getColor()
		} else {
			color = [UInt8(0), UInt8(0), UInt8(0)]
		}
		let _ = device.sendStaticColor(data: color)
	}
	
	@objc func resumeScreenGrabber(notification: NSNotification) {
		if(config.isSettingComplete()) {
			startStrip()
		}
	}
	
	@objc func updateSetting() {
		device.setEndpoint(endpoint:  config.getEndpoint()!)
		screenGrabber?.setLedCount(count: config.getLedCount())
		screenGrabber?.setLedDirection(direction:  config.getLedDirection())
	}
    
    @objc private func didWakeNotification(note: NSNotification) {
        startStrip()
    }

    @objc private func willSleepNotification(note: NSNotification) {
        stopStrip()
    }
    
}

extension AppDelegate: ScreenGrabberDelegate {
	func dataDidUpdated(data: [UInt8]) {
		let success = device.sendScreenBuffer(data: data)
		if !success {
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
		startStrip()
		timeoutCount = 0
	}
}



