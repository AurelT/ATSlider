//
//  ATSlider.swift
//  Pods
//
//  Created by Aurélien Tison on 01/08/2016.
//
//

import UIKit

@IBDesignable public class ATSlider: UIControl {
    
    // MARK: - Privates variables
    
    private var backgroundView: UIView!
    private var sliderView: UIView!
    private var sliderBackgroundView: UIView!
    private var cursorView: UIView!
    
    private var currentPosLabel: UILabel!
    private var maxLabel: UILabel!
    private var minLabel: UILabel!
    
    private var isFloatingPoint: Bool {
        get { return step % 1 != 0 ? true : false }
    }
    
    // MARK: - Publics variables
    
    public var getTextForValueAtIndexAction: ((index: Int) -> String)?
    public var textAlignement: NSTextAlignment = .Center
    
    // MARK: - Inspectables variables
    
    // Global
    @IBInspectable public var textColor: UIColor = UIColor.grayColor()
    @IBInspectable public var mainBackgroundColor: UIColor = UIColor.clearColor()
    @IBInspectable public var sliderOffset: CGFloat = 0
    
    // Cursor
    @IBInspectable public var cursorSize: CGFloat = 20
    @IBInspectable public var cursorColor: UIColor = UIColor.grayColor()
    
    // Slider
    @IBInspectable public var sliderColor: UIColor = UIColor.blueColor()
    @IBInspectable public var sliderWidth: CGFloat = 1
    
    // Min / max
    @IBInspectable public var numberOfValues: Int = 50
    @IBInspectable public var showMinMax: Bool = false {
        didSet {
            self.minLabel.hidden = !self.showMinMax
            self.maxLabel.hidden = !self.showMinMax
        }
    }
    @IBInspectable public var step: Double = 1
    @IBInspectable var sliderUnselectedColor: UIColor = UIColor.lightGrayColor()
    
    // Pin
    @IBInspectable public var pinBackgroundColor: UIColor = UIColor.redColor()
    
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
            
            let position = Double(Int((positionFromMin * self.step) / self.step)) * self.step
            
            return Double(position)
            
        }
        
    }
    
    var disabled:Bool = false {
        didSet {
            self.sliderBackgroundView.alpha = self.disabled ? 0.4 : 1.0
            self.userInteractionEnabled = !self.disabled
        }
    }
    
    private var steps: Int {
        get {
            if self.step == 0 {
                
                return 1
                
            }
            else {
                
                return Int(round(Double(self.numberOfValues) / step)) + 1
                
            }
        }
    }
    
    private var maxPosition:Double {
        get {
            return 0
        }
    }
    
    private var minPosition:Double {
        get {
            return Double(sliderView.frame.height)
        }
    }
    
    private var stepheight:Double {
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
    
    private func setup() {
        
        self.backgroundView = UIView()
        self.backgroundView.userInteractionEnabled = false
        self.addSubview(self.backgroundView)
        
        self.sliderBackgroundView = UIView()
        self.sliderBackgroundView.userInteractionEnabled = false
        self.backgroundView.addSubview(self.sliderBackgroundView)
        
        self.sliderView = UIView()
        self.sliderView.userInteractionEnabled = false
        self.sliderBackgroundView.addSubview(self.sliderView)
        
        self.cursorView = UIView()
        self.cursorView.userInteractionEnabled = false
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Background view
        if self.sliderOffset != 0 {
            
            self.backgroundView.frame = CGRectMake(0,
                                                   0,
                                                   self.sliderOffset,
                                                   self.frame.size.height)
            
        }
        else {
            self.backgroundView.frame = CGRectMake(0,
                                                   0,
                                                   self.frame.size.width,
                                                   self.frame.size.height)
            
        }
        self.backgroundView.backgroundColor = self.mainBackgroundColor
        
        // Min label
        if self.showMinMax {
            
            self.minLabel.frame = CGRectMake(0,
                                             self.backgroundView.frame.height - 20,
                                             self.backgroundView.frame.width,
                                             20)
            
        }
        else {
            
            self.minLabel.frame = CGRectMake(0,
                                             self.backgroundView.frame.height,
                                             0,
                                             0)
            
        }
        self.minLabel.text = self.getTextForValueAtIndex(0)
        self.minLabel.textAlignment = .Center
        self.minLabel.textColor = self.textColor
        
        // Max label
        if self.showMinMax {
            
            self.maxLabel.frame = CGRectMake(0,
                                             5,
                                             self.backgroundView.frame.width,
                                             20)
            
        }
        else {
            
            self.maxLabel.frame = CGRectMake(0,
                                             5,
                                             self.backgroundView.frame.width,
                                             0)
            
        }
        
        self.maxLabel.text = self.getTextForValueAtIndex(Int(self.numberOfValues - 1))
        self.maxLabel.textAlignment = .Center
        self.maxLabel.textColor = self.textColor
        
        // Slider background view
        self.sliderBackgroundView.frame = CGRectMake(self.backgroundView.frame.width / 2 - self.sliderWidth / 2,
                                                     self.maxLabel.frame.height + (self.cursorSize / 2),
                                                     self.sliderWidth,
                                                     self.backgroundView.frame.height - self.maxLabel.frame.height - self.minLabel.frame.height - self.cursorSize)
        self.sliderBackgroundView.backgroundColor = self.sliderUnselectedColor
        
        // Slider view
        self.sliderView.frame = CGRectMake(0,
                                           self.sliderWidth / 2,
                                           self.sliderBackgroundView.frame.width,
                                           self.sliderBackgroundView.frame.height - self.sliderWidth)
        self.sliderView.backgroundColor = self.sliderColor
        
        // Cursor view
        self.cursorView.frame = CGRectMake(-(self.cursorSize - self.sliderWidth) / 2,
                                           self.sliderView.frame.height / 2 - self.cursorSize / 2,
                                           self.cursorSize,
                                           self.cursorSize)
        self.cursorView.layer.cornerRadius = self.cursorSize / 2
        self.cursorView.backgroundColor = self.cursorColor
        
        // Current position label
        if self.sliderOffset == 0 {
            
            self.currentPosLabel.frame = CGRectMake(self.cursorView.frame.width,
                                                    self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                    (self.frame.width / 2) - self.cursorView.frame.width,
                                                    self.cursorSize * 1.5)
            
        }
        else {
            
            self.currentPosLabel.frame = CGRectMake(self.cursorView.frame.width,
                                                    self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                    self.frame.width - self.backgroundView.frame.width,
                                                    self.cursorSize * 1.5)
            
        }
        
        self.currentPosLabel.text = self.getTextForValueAtIndex(Int(self.handlePosition))
        self.currentPosLabel.textAlignment = self.textAlignement
        self.currentPosLabel.textColor = self.textColor
        self.currentPosLabel.backgroundColor = self.pinBackgroundColor
        
    }
    
    // MARK: - UIControl
    
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        return true
        
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        let _ = self.handlePosition
        
        let point = touch.locationInView(self.sliderView)
        
        self.moveHandleToPoint(point)
        
        return true
        
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        let endPosition = self.handlePosition
        
        self.handlePosition = endPosition
        
    }
    
    public override func cancelTrackingWithEvent(event: UIEvent?) {
        super.cancelTrackingWithEvent(event)
        
    }
    
    // MARK: - Moving handle
    
    private func moveHandleToPoint(point:CGPoint) {
        
        var newY = point.y - CGFloat(self.cursorView.frame.height / 2)
        
        if newY < -self.cursorSize / 2 {
            
            newY = -self.cursorSize / 2
            
        }
        else if newY > self.sliderView.frame.height - self.cursorSize / 2 {
            
            newY = self.sliderView.frame.height - self.cursorSize / 2
            
        }
        
        self.cursorView.frame.origin.y = CGFloat(newY)
        
        self.currentPosLabel.frame = CGRectMake(self.cursorView.frame.width,
                                                self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                self.currentPosLabel.frame.width,
                                                self.currentPosLabel.frame.height)
        
        self.currentPosLabel.text = self.getTextForValueAtIndex(Int(self.handlePosition))
        
    }
    
    private func moveHandleToPosition(position:Double, animated:Bool = false) {
        
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
            
            self.currentPosLabel.frame = CGRectMake(self.cursorView.frame.width,
                                                    self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                    self.currentPosLabel.frame.width,
                                                    self.currentPosLabel.frame.height)
            
        }
        else {
            
            self.cursorView.frame.origin.y = newY - self.cursorSize / 2
            
            self.currentPosLabel.frame = CGRectMake(self.cursorView.frame.width,
                                                    self.cursorView.frame.origin.y - self.cursorSize * 0.5 / 2,
                                                    self.currentPosLabel.frame.width,
                                                    self.currentPosLabel.frame.height)
            
        }
        
        self.currentPosLabel.text = self.getTextForValueAtIndex(Int(position))
        
    }
    
    private func getTextForValueAtIndex(index: Int) -> String {
        
        // If we have a custom action
        if let lCustomAction = self.getTextForValueAtIndexAction {
            
            // We return the result
            return lCustomAction(index: index)
            
        }
        else {
            
            // We return the index of the value
            return "\(index)"
            
        }
        
    }
    
}
