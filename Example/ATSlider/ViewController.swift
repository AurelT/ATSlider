//
//  ViewController.swift
//  ATSlider
//
//  Created by Aurel Tyson on 08/01/2016.
//  Copyright (c) 2016 Aurel Tyson. All rights reserved.
//

import UIKit
import ATSlider

class ViewController: UIViewController {
    
    // MARK: - Graphics

    @IBOutlet weak var mainSlider: ATSlider!
    
    @IBOutlet weak var switchShowMinMax: UISwitch!
    
    @IBOutlet weak var sliderCursorSize: UISlider!
    @IBOutlet weak var sliderOffset: UISlider!
    @IBOutlet weak var sliderNumberOfValues: UISlider!
    @IBOutlet weak var sliderSteps: UISlider!
    @IBOutlet weak var sliderCursorBackground: UISlider!
    @IBOutlet weak var sliderSliderColor: UISlider!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Size
        self.sliderCursorSize.minimumValue = 5
        self.sliderCursorSize.maximumValue = 50
        
        // Offset
        self.sliderOffset.minimumValue = 0
        self.sliderOffset.maximumValue = 100
        
        // Number of values
        self.sliderNumberOfValues.minimumValue = 0
        self.sliderNumberOfValues.maximumValue = 100
        
        // Steps
        self.sliderSteps.minimumValue = 1
        self.sliderSteps.maximumValue = 100
        
        // Cursor color
        self.sliderCursorBackground.minimumValue = 0
        self.sliderCursorBackground.maximumValue = 1
        
        // Slider color
        self.sliderSliderColor.minimumValue = 0
        self.sliderSliderColor.maximumValue = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func actionSwitch(_ sender: UISwitch) {
        
        if sender == self.switchShowMinMax {
            
            self.mainSlider.showMinMax = sender.isOn
            
        }
        self.mainSlider.setNeedsLayout()
        
    }
    
    @IBAction func actionSlider(_ sender: UISlider) {
        
        if sender == self.sliderCursorSize {
            
            self.mainSlider.cursorSize = CGFloat(sender.value)
            
        }
        else if sender == self.sliderOffset {
            
            self.mainSlider.sliderOffset = CGFloat(sender.value)
            
        }
        else if sender == self.sliderNumberOfValues {
            
            self.mainSlider.numberOfValues = Int(sender.value)
            
        }
        else if sender == self.sliderSteps {
            
            self.mainSlider.step = Double(sender.value)
            
        }
        else if sender == self.sliderCursorBackground {
            
            self.mainSlider.cursorColor = UIColor(red: CGFloat(sender.value), green: CGFloat(sender.value) * 0.5, blue: CGFloat(sender.value), alpha: 1)
            
        }
        else if sender == self.sliderSliderColor {
            
            self.mainSlider.sliderColor = UIColor(red: CGFloat(sender.value), green: CGFloat(sender.value) * 0.5, blue: CGFloat(sender.value), alpha: 1)
            
        }
        self.mainSlider.setNeedsLayout()
        
    }
    
}

