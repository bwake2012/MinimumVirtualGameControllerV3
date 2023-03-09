// GameControllerAdapterProtocol.swift
//
// Created by Bob Wakefield on 1/1/22.
// for MinimumVirtualGameControllerV2
//
// Using Swift 5.0
// Running on macOS 12.0
//
// 
//

import UIKit
import GameController

protocol GameControllerAdapterProtocol: AnyObject {

    var connectedControllerIsVirtual: Bool { get }

    var connectedController: GCController? { get set }
    var virtualController: GCVirtualController? { get set }

    func setupGameControllerNotifications()
    func setupGameController(parentView: UIView, controls: [String])
    func takedownGameController()
    func hideVirtualGameController()
    func showVirtualGameController()
    func updateGameControllerStatus()

    func leftPadValueChanged(pad: GCControllerDirectionPad, xValue: Float, yValue: Float)
    func rightPadValueChanged(pad: GCControllerDirectionPad, xValue: Float, yValue: Float)

    func buttonXValueChanged(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void
    func buttonYValueChanged(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void
    func buttonAValueChanged(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void
    func buttonBValueChanged(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void
}

extension GameControllerAdapterProtocol {

    var connectedControllerIsVirtual: Bool { nil != connectedController && connectedController === virtualController?.controller }

    func setupGameControllerNotifications() {

        NotificationCenter.default.addObserver(forName: .GCControllerDidBecomeCurrent, object: nil, queue: nil, using: handleControllerDidConnect(_:))

        NotificationCenter.default.addObserver(forName: .GCControllerDidStopBeingCurrent, object: nil, queue: nil, using: handleControllerDidDisconnect(_:))
    }
    
    func setupGameController(parentView view: UIView, controls: [String]) {

        let virtualConfiguration = GCVirtualController.Configuration()
        virtualConfiguration.elements = Set<String>(controls)
        virtualController = GCVirtualController(configuration: virtualConfiguration)

        // Connect to the virtual controller if no physical controllers are available.
        if GCController.controllers().isEmpty {

            virtualController?.connect()
        }

        guard let controller = GCController.controllers().first else {
            return
        }

        registerGameController(controller)
    }

    func takedownGameController() {

        virtualController?.disconnect()
        virtualController = nil
    }

    func showVirtualGameController() {

        if nil == self.connectedController {
            self.virtualController?.connect()
        }

        debugLog("showVirtualGameController")
        self.updateGameControllerStatus()
    }

    func hideVirtualGameController() {

        if self.connectedControllerIsVirtual {
            self.virtualController?.disconnect()
        }

        debugLog("hideVirtualGameController")
        self.updateGameControllerStatus()
    }

    func handleControllerDidConnect(_ notification: Notification) {

        debugLog("handleControllerDidConnect")

        guard let gameController = notification.object as? GCController else
        {
            return
        }

        if gameController.vendorName != "Apple"
        {
            virtualController?.disconnect()
        }

        registerGameController(gameController)

        connectedController = gameController

        updateGameControllerStatus()
    }

    func handleControllerDidDisconnect(_ notification: Notification) {

        debugLog("handleControllerDidDisconnect")

        connectedController = nil

        guard let gameController = notification.object as? GCController else
        {
            return
        }

        unregisterGameController()

        if GCController.controllers().isEmpty && gameController.vendorName != "Apple"
        {
            virtualController?.connect()
        }

        updateGameControllerStatus()
    }

    // Connect the real or virtual game pad buttons and thumbsticks to the app
    func registerGameController(_ gameController: GCController) {

        var leftJoystick: GCControllerDirectionPad?
        var rightJoystick: GCControllerDirectionPad?

        var buttonA: GCControllerButtonInput?
        var buttonB: GCControllerButtonInput?

        var buttonX: GCControllerButtonInput?
        var buttonY: GCControllerButtonInput?

        if let gamePad = gameController.extendedGamepad
        {
            buttonA = gamePad.buttonA
            buttonB = gamePad.buttonB

            buttonX = gamePad.buttonX
            buttonY = gamePad.buttonY

            leftJoystick = gamePad.leftThumbstick
            rightJoystick = gamePad.rightThumbstick
        }

        buttonA?.valueChangedHandler = self.buttonAValueChanged(_:_:_:)

        buttonB?.valueChangedHandler = self.buttonBValueChanged(_:_:_:)

        buttonX?.valueChangedHandler = self.buttonXValueChanged(_:_:_:)

        buttonY?.valueChangedHandler = self.buttonYValueChanged(_:_:_:)

        leftJoystick?.valueChangedHandler = self.leftPadValueChanged(pad:xValue:yValue:)
        rightJoystick?.valueChangedHandler = self.rightPadValueChanged(pad:xValue:yValue:)
    }

    func unregisterGameController() {

    }
}
