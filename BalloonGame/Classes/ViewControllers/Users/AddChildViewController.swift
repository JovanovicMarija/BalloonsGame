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
import DeviceKit

class AddChildViewController: UIViewController {
    
    var existingUser: User?
    
    // IBOutlets
    @IBOutlet weak var constraintTopStackView: NSLayoutConstraint!

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    @IBOutlet weak var buttonPhoto: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet{
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                imageView.layer.cornerRadius = 50
            } else {
                imageView.layer.cornerRadius = 100
            }
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var buttonDone: RoundedButton! {
        didSet {
            buttonDone.backgroundColor = UIColor.mainColor()
        }
    }
    
    // properties
    var alphabet: [String]!
    
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
    
    let height: CGFloat = {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return 44
        } else {
            return 66
        }
    }()
    
    var changesMade = false // TODO: - sredi i za editovanje zvukova
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load letters
        let lettersPath = NSBundle.mainBundle().pathForResource("letters", ofType: "plist")
        alphabet = NSArray(contentsOfFile: lettersPath!) as! [String]
        
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
        let device = Device()

        if device == .iPhone4 || device == .iPhone4s ||
            device == .iPhone5 || device == .iPhone5c || device == .iPhone5s ||
        device == .Simulator(.iPhone4) || device == .Simulator(.iPhone4s) ||
        device == .Simulator(.iPhone5) || device == .Simulator(.iPhone5c) || device == .Simulator(.iPhone5s) {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
        }
    }
    
    func removeObservers() {
        let device = Device()
        
        if device == .iPhone4 || device == .iPhone4s ||
            device == .iPhone5 || device == .iPhone5c || device == .iPhone5s ||
            device == .Simulator(.iPhone4) || device == .Simulator(.iPhone4s) ||
            device == .Simulator(.iPhone5) || device == .Simulator(.iPhone5c) || device == .Simulator(.iPhone5s) {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let keyboardViewEndFrame = self.view.convertRect(keyboardScreenEndFrame, fromView: self.view.window)
            let heightBottomConstraint: CGFloat = notification.name == UIKeyboardWillHideNotification ? -22 : (UIDevice.currentDevice().orientation == .Portrait ? -22 : -64)
            
            UIView.animateWithDuration(duration.doubleValue,
                                       delay: 0,
                                       options: UIViewAnimationOptions(rawValue: UInt(curve.integerValue << 16)),
                                       animations: { () in
                                        // text view
                                        self.constraintTopStackView.constant = heightBottomConstraint                                        
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
            let title = NSLocalizedString("AlertTitleDiscardingChanges", comment: "Warning")
            let message = NSLocalizedString("AlertMessageDiscardingChanges", comment: "Are you sure you want to discard all changes?")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let titleNo = NSLocalizedString("No", comment: "No")
            let titleYes = NSLocalizedString("Yes", comment: "Yes")
            alert.addAction(UIAlertAction(title: titleNo, style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: titleYes, style: .Destructive, handler: { [unowned self] _ in
                self.navigationController?.popViewControllerAnimated(true)
                }))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    // MARK: - buttons
    @IBAction func buttonPhotoPressed(sender: AnyObject) {
        let title = NSLocalizedString("AlertTitlePhoto", comment: "Photo")
        let message = NSLocalizedString("AlertMessagePhoto", comment: "Choose a photo")
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        let titleTakePhoto = NSLocalizedString("ActionTakePhoto", comment: "Take a photo")
        actionSheet.addAction(UIAlertAction(title: titleTakePhoto, style: .Default, handler: { _ in
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        
        let titleChooseFromLibrary = NSLocalizedString("ActionChooseFromLibrary", comment: "Choose from library")
        actionSheet.addAction(UIAlertAction(title: titleChooseFromLibrary, style: .Default, handler: { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel, handler: { _ in
            
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    
    }
    
    @IBAction func buttonDonePressed(sender: AnyObject) {
        
        if let text = self.textField.text {
            if text.characters.count == 0 {
                // present alert view
                let title = NSLocalizedString("AlertTitleErrorNameMissing", comment: "Error")
                let message = NSLocalizedString("AlertMessageErrorNameMissing", comment: "Please add user name")
                let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default, handler: { _ in
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
        
        
//        for character in alphabet {
//            let entity = NSEntityDescription.entityForName("AudioWord", inManagedObjectContext: managedContext)
//            let letter = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! AudioWord
//            letter.id = NSUUID().UUIDString
//            letter.letter = String(character)
//            let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("\(character)", ofType: "m4a")!)
//            letter.path = String(url)
//            
//            // TODO: - ovde sam stala
//            //                user.arrayAudioWords
//        }
        
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
        
        return CGSize(width: cellSize, height: height)
    }
}

extension AddChildViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if firstTimePressedCollectionCell == false {
            playSoundForLetterAtIndex(indexPath.row)
        } else { // first time
            firstTimePressedCollectionCell = false
            // present the message
            let title = NSLocalizedString("AlertTitleSoundEditing", comment: "Did you know?")
            let message = NSLocalizedString("AlertMessageSoundEditing", comment: "To edit the word or the sound, long press the letter")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default, handler: { [unowned self] _ in
                self.playSoundForLetterAtIndex(indexPath.row)
                }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}