//
//  DrawingView.swift
//  DrawingDemo
//
//  Created by Pavan Kumar Reddy on 07/01/18.
//

import UIKit

class DrawingView: UIView
{
   
    var lineColor:UIColor = UIColor.orange
    var lineWidth:CGFloat!
    var path:UIBezierPath!
    var touchPoint:CGPoint!
    var startingPoint:CGPoint!
    var vcObj:ViewController?
    var lineEntryPoint:CGPoint!
    var mainPointsArray = [[PathLocation]]()
    var subPointsArray = [PathLocation]()
    
    override func layoutSubviews()
    {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        lineWidth = 10
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK:- Touch events 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        startingPoint = touch?.location(in: self)
        let objPath = PathLocation.init(startPoint: startingPoint, endPoint: startingPoint)
        subPointsArray.append(objPath)
        
        path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: startingPoint)
        drawShapeLayer()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
        let objPath = PathLocation.init(startPoint: startingPoint, endPoint: touchPoint)
        path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: touchPoint)
        startingPoint = touchPoint
        
        subPointsArray.append(objPath)
        drawShapeLayer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if subPointsArray.count != 0
        {
            mainPointsArray.append(subPointsArray)
        }
        
        subPointsArray.removeAll()
        vcObj?.resetBarButtons()
    }
    
    //MARK:- Undo event 
    func undo()
    {
        guard mainPointsArray.count != 0 else {
            return
        }
        
        mainPointsArray.removeLast()
        vcObj?.resetBarButtons()
        self.clearDrawing()
        for case let objPathArray in mainPointsArray
        {
            for case let point in objPathArray
            {
                path = UIBezierPath()
                path.move(to: point.startPoint)
                path.addLine(to: point.endPoint)
                drawShapeLayer()
            }
        }
    }
    
    //MARK:- Drawing 
    func drawShapeLayer()
    {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = "round"
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    //MARK:- Clear view 
    func clearDrawing()
    {
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
        vcObj?.resetBarButtons()
    }
    
    func resetCanvas()
    {
        mainPointsArray.removeAll()
        subPointsArray.removeAll()
        self.clearDrawing()
    }
    
    //MARK:- Image saving 
    func saveImage()
    {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, scale)
        self.layer.render(in:UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return}
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)
    {
        if let error = error
        {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            vcObj?.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            vcObj?.present(ac, animated: true)
        }
    }
    
}

struct PathLocation
{
    var startPoint:CGPoint
    var endPoint:CGPoint
}
