

import UIKit

class ViewController: UIViewController  , UIPopoverPresentationControllerDelegate , ColorPickerTableViewControllerDelegate {
    
    
    @IBOutlet var colorPicker: UIBarButtonItem!
    
    @IBOutlet var btnSave: UIBarButtonItem!
    @IBOutlet var btnReset: UIBarButtonItem!
    //var popover:UIPopoverPresentationController!
    var vc:ColorPickerTableViewController!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.addSubview(canvas)
    }
    
     //MARK:- BarButton display 
    func resetBarButtons()
    {
        if canvas.mainPointsArray.count != 0
        {
            self.navigationItem.leftBarButtonItem?.isEnabled  = true
            self.btnReset.isEnabled = true
            self.btnSave.isEnabled = true
        }
        else
        {
            self.navigationItem.leftBarButtonItem?.isEnabled  = false
            self.btnReset.isEnabled = false
            self.btnSave.isEnabled = false
        }
    }
    
    //MARK:- BarButton actions 
    @IBAction func actionReset(_ sender: UIBarButtonItem)
    {
        canvas.resetCanvas()
    }
    
    @IBAction func actionSave(_ sender: UIBarButtonItem)
    {
        canvas.saveImage()
    }
    
    @IBAction func actionUndo(_ sender: UIBarButtonItem)
    {
        canvas.undo()
    }
    
    func selectedColor(color: UIColor)
    {
        canvas.lineColor = color
        vc.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Color picker
    @IBAction func actionColorPicker(_ sender: UIBarButtonItem)
    {
        vc = ColorPickerTableViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        
        //Optional
        vc.preferredContentSize = CGSize.init(width: 140, height: 170)
        
        let popover = vc.popoverPresentationController!
        popover.barButtonItem = sender
        popover.delegate = self
        present(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool
    {
        return true
    }
    
    //MARK:- DrawingView
    lazy var canvas:DrawingView = {
        let objView = DrawingView.init(frame:self.view.bounds)
        objView.vcObj = self
        return objView
    }()
    
}

