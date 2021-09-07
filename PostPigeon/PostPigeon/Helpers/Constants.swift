//
//  Constants.swift
//  PostPigeon
//
//  Created by Oleksandr Kurtsev on 21/06/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

// MARK: - Colors & Fonts

struct Colors {
    static let niceWhite            = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    static let niceBlue             = UIColor(red:  71/255, green: 108/255, blue: 137/255, alpha: 1)
    static let niceRed              = UIColor(red: 213/255, green:  51/255, blue:  51/255, alpha: 1)
    static let niceDark             = UIColor(red:  51/255, green:  51/255, blue:  51/255, alpha: 1)
    static let niceViolet           = UIColor(red: 142/255, green:  90/255, blue: 247/255, alpha: 1)
    static let mainWhite            = UIColor(red: 242/255, green: 243/255, blue: 244/255, alpha: 1)
    static let lightViolet          = UIColor(red: 201/255, green: 161/255, blue: 240/255, alpha: 1)
    static let lightBlue            = UIColor(red: 122/255, green: 178/255, blue: 235/255, alpha: 1)
    static let niceGray             = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
}

struct Fonts {
    static let avenir36             = UIFont(name: "AvenirNextCondensed-DemiBold", size: 36)
    static let avenir26             = UIFont(name: "AvenirNextCondensed-DemiBold", size: 26)
    static let avenir20             = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
    static let avenir16             = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)
    static let laoSangam18          = UIFont(name: "Lao Sangam MN", size: 18)
    static let laoSangam20          = UIFont(name: "Lao Sangam MN", size: 20)
}

// MARK: - Image Names

let kImageSystemCamera              = "camera"
let kImageSystemSmiley              = "smiley"
let kImageSystemPeople              = "person.2"
let kImageSystemConv                = "bubble.left.and.bubble.right"

let kImageNameBackground            = "background"
let kImageNameEmail                 = "email"
let kImageNameAvatar                = "avatar"
let kImageNameCancel                = "cancel"
let kImageNamePassword              = "password"
let kImageNameShowPass              = "showpass"
let kImageNameHidePass              = "hidepass"
let kImageNameLocation              = "location"
let kImageNameHome                  = "home"
let kImageNamePin                   = "pin"
let kImageNameSent                  = "sent"

// MARK: - Button Names

let kButtonAccept                   = "ACCEPT"
let kButtonDeny                     = "Deny"
let kButtonLogin                    = "Login"
let kButtonDone                     = "Done"
let kButtonNext                     = "Next"
let kButtonSave                     = "Save"
let kButtonCancel                   = "Cancel"
let kButtonBack                     = "Back"
let kButtonSend                     = "Send"
let kButtonRestore                  = "Restore password"
let kButtonRegistration             = "Registration"

// MARK: - TextField Placeholders

let kPlaceholderPassword            = "Enter your password"
let kPlaceholderConfirmPass         = "Confirm your password"
let kPlaceholderEmail               = "your_email@gmail.com"
let kPlaceholderFirstName           = "Enter your name"
let kPlaceholderLastName            = "Enter your surname"
let kPlaceholderBornDate            = "Enter your born date"
let kPlaceholderAddress             = "Enter your home address"
let kPlaceholderPhone               = "Enter your phone number"
let kPlaceholderWriteSomething      = "Write something here..."

// MARK: - SegmentedControl Titles

let kSegmentedMan                   = "Man"
let kSegmentedWoman                 = "Woman"
let kSegmentedOther                 = "Other"

// MARK: - Alert Titles & Message

let kAlertTitleSuccess              = "Success"
let kAlertTitleError                = "Error"
let kAlertTitleOk                   = "Okey"
let kAlertTitleCamera               = "Camera"
let kAlertTitleGallery              = "Gallery"
let kAlertTitleCancel               = "Cancel"
let kAlertTitlePhotoNotExist        = "Photo not exist"
let kAlertTitleDeniedLocation       = "Your Location is not Availeble"
let kAlertTitleCheckLocation        = "Location Services are Disabled"
let kAlertTitleCannotGetUserInfo    = "Unable to load user information from FireBase"
let kAlertTitleNotFilled            = "Fill in all the input fields"
let kAlertTitleInvalidEmail         = "Email format is not valid"
let kAlertTitlePassNotMatched       = "Passwords not matched"
let kAlertTitleServerError          = "Server error"
let kAlertTitleUnknownError         = "Unknown error"
let kAlertTitleCannotUnwrapToMUser  = "It is impossible to convert User to MUser"

let kAlertMessYouAreAuthorized      = "You are authorized!"
let kAlertMessRecovery              = "Password recovery link sent to your email"
let kAlertMessYouAreRegistered      = "You are registered"
let kAlertMessDeniedLocation        = "To give permission Go to: Settings -> iTraveler -> Location"
let kAlertMessCheckLocation         = "To enable it go: Settings -> Privacy -> Location Services and turn On"
let kAlertMessRestrictedLocation    = "Application is not authorized for location services"
let kAlertMessWrongPhoneNumber      = "Wrong phone number"
let kAlertMessPleaseWait            = "Please wait. Account creation"
let kAlertMessMessageHasBeenSent    = "Your message has been sent"
// MARK: - Other

let kTitleConversations             = "Conversations"
let kTitlePeoples                   = "Peoples"
let kTitleNewChat                   = "You have the opportunity to start a new chat"

let kHeaderWaitingChats             = "Waiting chats"
let kHeaderActiveChats              = "Active chats"
let kHeaderOnlinePeople             = "registered people"

