

import UIKit

class ViewController: UIViewController {

    @IBOutlet var btnSave: UIBarButtonItem!
    @IBOutlet var btnReset: UIBarButtonItem!
    
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
    
    //MARK:- DrawingView
    lazy var canvas:DrawingView = {
        let objView = DrawingView.init(frame:self.view.bounds)
        objView.vcObj = self
        return objView
    }()
    
}

