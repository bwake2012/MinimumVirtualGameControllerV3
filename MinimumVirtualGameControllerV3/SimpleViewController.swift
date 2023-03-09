// SimpleViewController.swift
//
// Created by Bob Wakefield on 3/6/23.
// for MinimumVirtualGameControllerV3
//
// Using Swift 5.0
// Running on macOS 13.2
//
// 
//

import UIKit
import GameController

class SimpleViewController: UIViewController, GameControllerAdapterProtocol {

    private static let valueFormatter: NumberFormatter = {

        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        return formatter
    }()

    @IBOutlet var status: UILabel?

    @IBOutlet var buttonX: UILabel?
    @IBOutlet var buttonY: UILabel?
    @IBOutlet var buttonA: UILabel?
    @IBOutlet var buttonB: UILabel?
    @IBOutlet var leftThumbStickX: UILabel?
    @IBOutlet var leftThumbStickY: UILabel?
    @IBOutlet var rightThumbStickX: UILabel?
    @IBOutlet var rightThumbStickY: UILabel?

    private var configurationElements: [String] =
        [
            GCInputRightThumbstick,
            GCInputButtonA,
            GCInputButtonB,
            GCInputButtonX
        ]

    var connectedController: GCController?

    var virtualController: GCVirtualController?

    func updateGameControllerStatus() {
        status?.text = connectedController?.vendorName ?? "Not Connected"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGameControllerNotifications()

        UIView.animate(withDuration: 0.3) {
            self.setupGameController(parentView: self.view, controls: self.configurationElements)
        }
    }

    override func viewWillAppear(_ animated: Bool) {

        debugLog("viewWillAppear")

        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.3) {
            self.showVirtualGameController()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {

        debugLog("viewDidDisappear")

        super.viewDidDisappear(animated)

        self.hideVirtualGameController()
    }
}

extension SimpleViewController {

    internal func buttonAValueChanged(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void {

        // Put here the codes to run when button A clicked
        let pressedString = pressed ? "Pressed \(value)" : "Not Pressed"
        debugLog("Button A \(value) \(pressedString)")

        buttonA?.text = pressedString
    }

    internal func buttonBValueChanged(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void {

        // Put here the codes to run when button B clicked
        let pressedString = pressed ? "Pressed \(value)" : "Not Pressed"
        debugLog("Button B \(value) \(pressedString)")

        buttonB?.text = pressedString
    }

    internal func buttonXValueChanged(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void {

        // Put here the codes to run when button X clicked
        let pressedString = pressed ? "Pressed \(value)" : "Not Pressed"
        debugLog("Button X \(value) \(pressedString)")

        buttonX?.text = pressedString
    }

    internal func buttonYValueChanged(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void {

        // Put here the codes to run when button Y clicked
        let pressedString = pressed ? "Pressed \(value)" : "Not Pressed"
        debugLog("Button Y \(value) \(pressedString)")

        buttonY?.text = pressedString
    }

    func leftPadValueChanged(pad: GCControllerDirectionPad, xValue: Float, yValue: Float) {

        leftThumbStickX?.text = Self.valueFormatter.string(for: xValue)
        leftThumbStickY?.text = Self.valueFormatter.string(for: yValue)
    }

    func rightPadValueChanged(pad: GCControllerDirectionPad, xValue: Float, yValue: Float) {

        rightThumbStickX?.text = Self.valueFormatter.string(for: xValue)
        rightThumbStickY?.text = Self.valueFormatter.string(for: yValue)
    }
}
