//
//  ATSlider.swift
//  Pods
//
//  Created by Aurélien Tison on 01/08/2016.
//
//

import UIKit

@IBDesignable open class ATSlider: UIControl {
    
    // MARK: - Privates variables
    
    fileprivate var backgroundView: UIView!
    fileprivate var sliderView: UIView!
    fileprivate var sliderBackgroundView: UIView!
    fileprivate var cursorView: UIView!
    
    fileprivate var currentPosLabel: UILabel!
    fileprivate var maxLabel: UILabel!
    fileprivate var minLabel: UILabel!
    
    fileprivate var isFloatingPoint: Bool {
        get { return step.truncatingRemainder(dividingBy: 1) != 0 ? true : false }
    }
    
    // MARK: - Publics variables
    
    open var getTextForValueAtIndexAction: ((_ index: Int) -> String)?
    open var textAlignement: NSTextAlignment = .center
    
    // MARK: - Inspectables variables
    
    // Global
    @IBInspectable open var textColor: UIColor = UIColor.gray
    @IBInspectable open var mainBackgroundColor: UIColor = UIColor.clear
    @IBInspectable open var sliderOffset: CGFloat = 0
    
    // Cursor
    @IBInspectable open var cursorSize: CGFloat = 20
    @IBInspectable open var cursorColor: UIColor = UIColor.gray
    
    // Slider
    @IBInspectable open var sliderColor: UIColor = UIColor.blue
    @IBInspectable open var sliderWidth: CGFloat = 1
    
    // Min / max
    @IBInspectable open var numberOfValues: Int = 50
    @IBInspectable open var showMinMax: Bool = false {
        didSet {
            self.minLabel.isHidden = !self.showMinMax
            self.maxLabel.isHidden = !self.showMinMax
        }
    }
    @IBInspectable open var step: Double = 1
    @IBInspectable var sliderUnselectedColor: UIColor = UIColor.lightGray
    
    // Pin
    @IBInspectable open var pinBackgroundColor: UIColor = UIColor.red
    
    /**
     the position of the handle. The handle moves animated when setting the variable
     */
    var handlePosition: Double {
        set (newHandlePosition) {
            self.moveHandleToPosition(newHandlePosition, animated: true)
        }
        get {
            
            let currentY = self.cursorView.frame.origin.y + self.cursorSize / 2
            
            let positionFromMin = -(Double(currentY) - self.minPosition - self.stepheight / 2) / self.stepheight
            
            if !positionFromMin.isNaN {
                
                return Double(Int((positionFromMin * self.step) / self.step)) * self.step
                
            }
            else {
                
                return 0
                
            }
            
        }
        
    }
    
    var disabled:Bool = false {
        didSet {
            self.sliderBackgroundView.alpha = self.disabled ? 0.4 : 1.0
            self.isUserInteractionEnabled = !self.disabled
        }
    }
    
    fileprivate var steps: Int {
        get {
            if self.step == 0 {
                
                return 1
                
            }
            else {
                
                return Int(round(Double(self.numberOfValues) / step)) + 1
                
            }
        }
    }
    
    fileprivate var maxPosition:Double {
        get {
            return 0
        }
    }
    
    fileprivate var minPosition:Double {
        get {
            return Double(sliderView.frame.height)
        }
    }
    
    fileprivate var stepheight:Double {
        get {
            return (self.minPosition - self.maxPosition) / Double(self.steps - 1)
        }
    }
    
    // MARK: - Init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configuration
        self.setup()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Configuration
        self.setup()
        
    }
    
    // MARK: - Configuration
    
    fileprivate func setup() {
        
        self.backgroundView = UIView()
        self.backgroundView.isUserInteractionEnabled = false
        self.addSubview(self.backgroundView)
        
        self.sliderBackgroundView = UIView()
        self.sliderBackgroundView.isUserInteractionEnabled = false
        self.backgroundView.addSubview(self.sliderBackgroundView)
        
        self.sliderView = UIView()
        self.sliderView.isUserInteractionEnabled = false
        self.sliderBackgroundView.addSubview(self.sliderView)
        
        self.cursorView = UIView()
        self.cursorView.isUserInteractionEnabled = false
        self.cursorView.clipsToBounds = true
        self.sliderView.addSubview(self.cursorView)
        
        self.minLabel = UILabel()
        self.backgroundView.addSubview(self.minLabel)
        
        self.maxLabel = UILabel()
        self.backgroundView.addSubview(self.maxLabel)
        
        self.currentPosLabel = UILabel()
        self.sliderBackgroundView.addSubview(self.currentPosLabel)
        
    }
    
    // MARK - View
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Background view
        if self.sliderOffset != 0 {
            
            self.backgroundView.frame = CGRect(x: 0,
                                                   y: 0,
                                                   width: self.sliderOffset,
                                                   height: self.frame.size.height)
            
        }
        else {
            self.backgroundView.frame = CGRect(x: 0,
                                                   y: 0,
                                                   width: self.frame.size.width,
                                                   height: self.frame.size.height)
            
        }
        self.backgroundView.backgroundColor = self.mainBackgroundColor
        
        // Min label
        if self.showMinMax {
            
            self.minLabel.frame = CGRect(x: 0,
                                             y: self.backgroundView.frame.height - 20,
                                             width: self.backgroundView.frame.width,
                                             height: 20)
            
        }
        else {
            
            self.minLabel.frame = CGRect(x: 0,
                                             y: self.backgroundView.frame.height,
                                             width: 0,
                                             height: 0)
            
        }
        self.minLabel.text = self.getTextForValueAtIndex(0)
        self.minLabel.textAlignment = .center
        self.minLabel.textColor = self.textColor
        
        // Max label
        if self.showMinMax {
            
            self.maxLabel.frame = CGRect(x: 0,
                                             y: 5,
                                             width: self.backgroundView.frame.width,
                                             height: 20)
            
        }
        else {
            
            self.maxLabel.frame = CGRect(x: 0,
                                             y: 5,
                                             width: self.backgroundView.frame.width,
                                             height: 0)
            
        }
        
        self.maxLabel.text = self.getTextForValueAtIndex(Int(self.numberOfValues - 1))
        self.maxLabel.textAlignment = .center
        self.maxLabel.textColor = self.textColor
        
        // Slider background view
        self.sliderBackgroundView.frame = CGRect(x: self.backgroundView.frame.width / 2 - self.sliderWidth / 2,
                                                     y: self.maxLabel.frame.height + (self.cursorSize / 2),
                                                     width: self.sliderWidth,
                                                     height: self.backgroundView.frame.height - self.maxLabel.frame.height - self.minLabel.frame.height - self.cursorSize)
        self.sliderBackgroundView.backgroundColor = self.sliderUnselectedColor
        
        // Slider view
        self.sliderView.frame = CGRect(x: 0,
                                           y: self.sliderWidth / 2,
                                           width: self.sliderBackgroundView.frame.width,
                                           height: self.sliderBackgroundView.frame.height - self.sliderWidth)
        self.sliderView.backgroundColor = self.sliderColor
        
        // Cursor view
        self.cursorView.frame = CGRect(x: -(self.cursorSize - self.sliderWidth) / 2,
                                           y: self.sliderView.frame.height / 2 - self.cursorSize / 2,
                                           width: self.cursorSize,
                                           height: self.cursorSize)
        self.cursorView.layer.cornerRadius = self.cursorSize / 2
        self.cursorView.backgroundColor = self.cursorColor
        
        // Current position label
        if self.sliderOffset == 0 {
            
            self.currentPosLabel.frame = CGRect(x: self.cursorView.frame.width,
                                                    y: self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                    width: (self.frame.width / 2) - self.cursorView.frame.width,
                                                    height: self.cursorSize * 1.5)
            
        }
        else {
            
            self.currentPosLabel.frame = CGRect(x: self.cursorView.frame.width,
                                                    y: self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                    width: self.frame.width - self.backgroundView.frame.width,
                                                    height: self.cursorSize * 1.5)
            
        }
        
        self.currentPosLabel.text = self.getTextForValueAtIndex(Int(self.handlePosition))
        self.currentPosLabel.textAlignment = self.textAlignement
        self.currentPosLabel.textColor = self.textColor
        self.currentPosLabel.backgroundColor = self.pinBackgroundColor
        
    }
    
    // MARK: - UIControl
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        return true
        
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let _ = self.handlePosition
        
        let point = touch.location(in: self.sliderView)
        
        self.moveHandleToPoint(point)
        
        return true
        
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        let endPosition = self.handlePosition
        
        self.handlePosition = endPosition
        
    }
    
    open override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        
    }
    
    // MARK: - Moving handle
    
    fileprivate func moveHandleToPoint(_ point:CGPoint) {
        
        var newY = point.y - CGFloat(self.cursorView.frame.height / 2)
        
        if newY < -self.cursorSize / 2 {
            
            newY = -self.cursorSize / 2
            
        }
        else if newY > self.sliderView.frame.height - self.cursorSize / 2 {
            
            newY = self.sliderView.frame.height - self.cursorSize / 2
            
        }
        
        self.cursorView.frame.origin.y = CGFloat(newY)
        
        self.currentPosLabel.frame = CGRect(x: self.cursorView.frame.width,
                                                y: self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                width: self.currentPosLabel.frame.width,
                                                height: self.currentPosLabel.frame.height)
        
        self.currentPosLabel.text = self.getTextForValueAtIndex(Int(self.handlePosition))
        
    }
    
    fileprivate func moveHandleToPosition(_ position:Double, animated:Bool = false) {
        
        if self.step == 0 {
            
            return
            
        }
        
        var goPosition = position
        
        if position >= Double(self.numberOfValues) {
            
            goPosition = Double(self.numberOfValues)
            
        }
        else if position <= 0 {
            
            goPosition = 0
            
        }
        
        let positionFromMin = goPosition / self.step
        
        let newY = CGFloat(self.minPosition - positionFromMin * self.stepheight)
        
        if animated {
            
            self.cursorView.frame.origin.y = newY - self.cursorSize / 2
            
            self.currentPosLabel.frame = CGRect(x: self.cursorView.frame.width,
                                                    y: self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                    width: self.currentPosLabel.frame.width,
                                                    height: self.currentPosLabel.frame.height)
            
        }
        else {
            
            self.cursorView.frame.origin.y = newY - self.cursorSize / 2
            
            self.currentPosLabel.frame = CGRect(x: self.cursorView.frame.width,
                                                    y: self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                    width: self.currentPosLabel.frame.width,
                                                    height: self.currentPosLabel.frame.height)
            
        }
        
        self.currentPosLabel.text = self.getTextForValueAtIndex(Int(position))
        
    }
    
    fileprivate func getTextForValueAtIndex(_ index: Int) -> String {
        
        // If we have a custom action
        if let lCustomAction = self.getTextForValueAtIndexAction {
            
            // We return the result
            return lCustomAction(index)
            
        }
        else {
            
            // We return the index of the value
            return "\(index)"
            
        }
        
    }
    
}
