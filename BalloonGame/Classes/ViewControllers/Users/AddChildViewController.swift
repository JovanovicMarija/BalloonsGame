//
//  AddChildViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/6/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class AddChildViewController: UIViewController {
    
    var existingUser: User?
    
    // IBOutlets
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet weak var buttonPhoto: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet{
            imageView.layer.cornerRadius = imageView.frame.size.height/2
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var buttonDone: RoundedButton! {
        didSet {
            buttonDone.backgroundColor = UIColor.mainColor()
        }
    }
    
    // properties
    var alphabet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                                  "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    var firstTimePressedCollectionCell = true
    
    var audioPlayer = AVAudioPlayer()

    var longGesture: UILongPressGestureRecognizer!
    
    var cellSize: CGFloat = {
        let ret: CGFloat
        if UIDevice.currentDevice().orientation == .Portrait {
            ret = (UIScreen.mainScreen().bounds.size.width - 40 - 3*15)/5 // odokativno
        } else {
            ret = (UIScreen.mainScreen().bounds.size.width - 40 - 7*15)/9 // odokativno
        }
        
        return ret > 44 ? ret : 44
    }()
    
    var changesMade = false // TODO: - sredi i za editovanje zvukova
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // check if there is existing child
        if let existingUser = existingUser {
            imageView.image = UIImage(data: existingUser.photo!)
            textField.text = existingUser.name!
        }
        
        // text field
        textField.addTarget(self, action: #selector(AddChildViewController.textFieldDidChange), forControlEvents: .EditingChanged)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    // MARK: - Notifications
    func addObservers() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let keyboardViewEndFrame = self.view.convertRect(keyboardScreenEndFrame, fromView: self.view.window)
            let heightBottomConstraint = notification.name == UIKeyboardWillHideNotification ? 0 : -keyboardViewEndFrame.height
            
            UIView.animateWithDuration(duration.doubleValue,
                                       delay: 0,
                                       options: UIViewAnimationOptions(rawValue: UInt(curve.integerValue << 16)),
                                       animations: { () in
                                        // text view
//                                        self.bottomConstraint.constant = heightBottomConstraint
                                        
                                        self.view.layoutIfNeeded()
                },
                                       completion: nil
            )
        }
    }
    
    // MARK: -
    func textFieldDidChange(textField: UITextField) {
        // changes to user made
        changesMade = true
    }
    
    @IBAction func buttonBackPressed(sender: AnyObject) {
        if changesMade {
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to discard all changes?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { [unowned self] _ in
                self.navigationController?.popViewControllerAnimated(true)
                }))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    // MARK: - buttons
    @IBAction func buttonPhotoPressed(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Photo", message: "Choose a photo", preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take a photo", style: .Default, handler: { _ in
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose from library", style: .Default, handler: { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    
    }
    
    @IBAction func buttonDonePressed(sender: AnyObject) {
        
        if let text = self.textField.text {
            if text.characters.count == 0 {
                // present alert view
                let alert = UIAlertController(title: "Error", message: "Please add user name", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in
                    self.textField.becomeFirstResponder()
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            var user: User? = nil
            if existingUser == nil {
                user = createNewUser()
            } else {
                if changesMade {
                    user = editExistingUser()
                } // else nothing
            }
            
            // remember user as last user in userDefaults
            Manager.sharedInstance.currentUser = user
            NSUserDefaults.standardUserDefaults().setObject(user!.id, forKey: userDefaults.LastUser.rawValue)
        }
    }
    
    func createNewUser() -> User? {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("User",
                                                        inManagedObjectContext:managedContext)
        
        let user = NSManagedObject(entity: entity!,
                                   insertIntoManagedObjectContext: managedContext) as! User
        
        //3
        user.id = NSUUID().UUIDString
        user.name = textField.text
        if let photo = imageView.image {
            user.photo = UIImagePNGRepresentation(photo)
        }
        
        
        for character in alphabet {
            let entity = NSEntityDescription.entityForName("AudioWord", inManagedObjectContext: managedContext)
            let letter = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! AudioWord
            letter.id = NSUUID().UUIDString
            letter.letter = String(character)
            let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("\(character)", ofType: "m4a")!)
            letter.path = String(url)
            
            // TODO: - ovde sam stala
            //                user.arrayAudioWords
        }
        
        //4
        do {
            try managedContext.save()
            return user
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func editExistingUser() -> User? {

        // 1
        existingUser?.name = textField.text
        existingUser?.photo = UIImagePNGRepresentation(imageView.image!)
        
        // 2
        do {
            try existingUser?.managedObjectContext?.save()
            return existingUser
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return nil
        }
    }
    
    // MARK: - TextField
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.textField.isFirstResponder() {
            self.textField.resignFirstResponder()
        }
    }
    
    // MARK: - play sound
    func playSoundForLetterAtIndex(index: Int) {
        let coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("\(alphabet[index])", ofType: "m4a")!)
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: coinSound)
        } catch {
            print("playLetter")
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    // MARK: - gesture
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .Ended {
            // present modal view
            let modalViewController = self.storyboard?.instantiateViewControllerWithIdentifier("recordWordViewController") as! RecordWordViewController
            modalViewController.letter = (sender.view as! AddChildCollectionViewCell).letter
            modalViewController.modalPresentationStyle = .OverCurrentContext
            presentViewController(modalViewController, animated: true, completion: nil)
        }
    }
}

extension AddChildViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AddChildViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // changes to user made
        changesMade = true
        // update interface
        self.imageView.image = image
        // dismiss
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AddChildViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alphabet.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! AddChildCollectionViewCell
        
        cell.letter = alphabet[indexPath.row]
        cell.labelLetter.text = "\(alphabet[indexPath.row])"
        cell.labelLetter.textColor = UIColor.whiteColor()
        
        // gesture
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(longGesture)
        
        return cell
    }
}

extension AddChildViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: cellSize, height: 44)
    }
}

extension AddChildViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if firstTimePressedCollectionCell == false {
            playSoundForLetterAtIndex(indexPath.row)
        } else { // first time
            firstTimePressedCollectionCell = false
            // present the message
            let alert = UIAlertController(title: "Did you know?", message: "To edit the word or the sound, long press the letter", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [unowned self] _ in
                self.playSoundForLetterAtIndex(indexPath.row)
                }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}