#Instagram Project
### 0. Preliminary
* open the project through **Instagram.xcworkspace**
* We are using [storyboard reference](https://www.shinobicontrols.com/blog/ios9-day-by-day-day3-storyboard-references) in this group project. 

### 1. Tools and Techniques we use

* **[Cocopods](https://cocoapods.org/)** - CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.
It has over 51 thousand libraries and is used in over 3 million apps.
CocoaPods can help you scale your projects elegantly.

* **[Alamofire](https://github.com/Alamofire/Alamofire)** - We communicate with server through API requests. API end points and communication format will be decided later.
**Alamofire** is an HTTP networking library written in Swift. It will be used as the http tools in this project.

* **[AlamofireImage](https://github.com/Alamofire/AlamofireImage)** - We load image with url returned from server asynchronously to utilize the UI feedback.
**AlamofireImage** is an image component library for Alamofire. We use the async image loading method in it.

### 2. Instagram Project Marking Guide


##### 2.1 Errors are treated correctly
* Errors like linking outlet missing, component/segue identities missing are checked and fixed during development
* For APIs, the parameters in requests from client and the responses from server are carefully checked to make sure all the field requested are existed and no nil error will occur.

##### 2.2 Register and login screen
* Instagram style layout
* support switch from resume existing account, login as another account and register for a new account.

##### 2.3 Functional Tab Bar at bottom of screen with icons
* Tab bar view controller
* fake center upload photo tab. Instead, pop up another view controller for photo uploading without changing the selected tab bar item index.

---
#### User Feed

##### 2.4 User Feed - Scroll through photos and comments
* Instagram style layouts using UICollectionView
* Flow layout to auto set the height of the cell
* Cell element is user interactive, can lead to user profile, like and comment view

##### 2.5 Used Feed - Like a photo and display users who liked a photo in the feed
* Instagram style layout
    * if the use hasn't liked this photo, fill the Heart icon will red color when user touch on it
    * if the use has liked this photo, make the Heart icon back to hollow again
    * introduce hapticFeedback when touched
* Navigate to a new view to show who liked a photo

##### 2.6 Used Feed - Leave a comment
* Instagram style layout
* Adjust the y position of the view when keyboard is enabled to keep the text input in the view


##### 2.7 Used Feed - Sort by both date/time and location
* Sort button is put at the top right corner of the header

---
#### Discover

##### 2.8 Discover - Search for Users
* Instagram style layout
    * search bar in the navigation title view
    * suggested users are displayed as default
* Server sends back search result whenever user has changed the input value
* When user touch on a particular searched user, user profile view is displayed
* If no searched user, a label will indicate that

##### 2.9 Discover - Display suggested users to follow
* suggested users are displayed as default
* When user touch on a particular suggested user, user profile view is displayed
* If no suggested user, a label will indicate that

##### 2.10 Discover - Algorithm to suggest users
In our user suggestion algorithm, ten different features are adopted, and they are:

* He follows you, but you haven't followed him back
* The number of common followers you and he share
* The number of users that you and he both follow
* You follow group A, group B follows him -> Dice Similarity between A and B
* The number of photos that you and he both like
* The number of photos that you and he both commented
* The number of his photos that you liked
* The number of his photos that you commented
* The number of your photos that he commented
* The number of your photos that he liked

Additionally, if you followed him before, but later unfollowed him, then he won't appear in your friend suggestion list.

Each feature is assigned a separate weight, and all the ten weights sum up to 1.

Each candidate will receive a score, which is sum of 10 weights times 10 features. Finally, all candidates are ranked according to their score. A higher score indicates a stronger candidate，and will show at the top of the suggestion list.


---

#### Photo
When uer touch photo icon on the tab bar, let user select whether take the photo from camera or select the photo from album

Use a navigation view controller to go through all the process before uploading

##### 2.11 Photo - Take a photo with camera while providing flash options
[UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller)

##### 2.12 Photo - Change brightness and contrast
* compress image before processing
* [Core Image](https://developer.apple.com/documentation/coreimage)

##### 2.13 Photo - Crop a photo
[TOCropViewController](https://github.com/TimOliver/TOCropViewController)

##### 2.14 Photo - Apply at least 3 different filters
* compress image before processing
* [Core Image](https://developer.apple.com/documentation/coreimage)

##### 2.15 Photo - Upload photo
* dismiss the pop up view controller when upload is finished

---
#### Activity Feed

##### 2.16 Activity Feed - Display users following that liked photos or started following user
* Instagram style layout
* Cell element is user interactive, can lead to user profile, photo detail and comment view
* If no following info, a label will indicate that

##### 2.17 Activity Feed - Display activity of users that current user are following
* Instagram style layout
* Cell element is user interactive, can lead to user profile, photo detail and comment view
* If no you info, a label will indicate that

---

#### Profile

##### 2.18 Profile - Display stats on posts, followers and following, profile pic
* Instagram style layout

##### 2.19 Profile - Display all user photos uploaded
* Instagram style layout
* Photos in cell are user interactive, can lead to photo detail view
* If no photo, a label will indicate that

---

##### 2.20 Bluetooth or WiFi Adhoc Feature - In Range Swiping, e.g. Swipe photos to friends nearby that they can view on feed with an "In Range" tag
* [MultipeerConnectivity](https://developer.apple.com/documentation/multipeerconnectivity)
* This functionality is displayed on each feed page, with two button on the top left corner. 
* The airdrop-like button is used to let the device send photo to other device in range.
* The airplay-like button is used to let the device search for device in range and ready to recieve button
* When the airdrop-like button is touched, there will be an additional share button on each feed, through which you can share the photo with the device in range.

##### 2.21 Network - Implement a server for communications or retrieve data from actual Instagram API

The server of our Instagram project is written in node.js (using AdonisJS framework), and is deployed on Heroku. The Database is deployed to ClearDB, and all the images uploaded by users are stored in Amazon S3.


##### 2.22 Code Quality
* appropriate comment is added
* views and controllers are well organized in different group
* storyboard reference is introduced to well arrange the development process and whole storyboard structure
