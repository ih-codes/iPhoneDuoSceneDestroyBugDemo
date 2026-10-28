//
// ViewController.swift
// Duo_Scene_Destroy_Bug
// Created on 2026-10-28, 2026. 
//  

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let windowSceneID = view.window?.windowScene?.session.persistentIdentifier {
            label.text = "Window Scene:\n\(windowSceneID)"
            view.backgroundColor = Self.lightColor(for: windowSceneID)
        }
    }

    /// Returns a light pastel color derived from `string`, so the same scene always gets the same color.
    /// Uses FNV-1a rather than `hashValue`, which is randomly seeded on each launch.
    private static func lightColor(for string: String) -> UIColor {
        var hash: UInt64 = 0xcbf29ce484222325
        for byte in string.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 0x100000001b3
        }
        let hue = CGFloat(hash % 360) / 360
        return UIColor(hue: hue, saturation: 0.3, brightness: 1.0, alpha: 1.0)
    }
}
