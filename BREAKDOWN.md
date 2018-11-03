#Instagram Project
### 0. Preliminary
* open the project through **Instagram.xcworkspace**
* We are using [storyboard reference](https://www.shinobicontrols.com/blog/ios9-day-by-day-day3-storyboard-references) in this group project. Work on your own storyboard in corresponding **/view** folder to keep the repo manageable

### 1. Tools and Techniques we use
* **[Core Data](https://medium.com/xcblog/core-data-with-swift-4-for-beginners-1fc067cca707)** - Core Data is one of the most popular frameworks provided by Apple for iOS and macOS apps.
Core data is used to manage the model layer object in our application.
You can treat Core Data as a framework to save, track, modify and filter the data within iOS apps, however, Core Data is not a Database.
Core Data is using SQLite as it’s persistent store but the framework itself is not the database.
Core Data does much more than databases like managing the object graphs, tracking the changes in the data and many more things.

* **[Cocopods](https://cocoapods.org/)** - CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.
It has over 51 thousand libraries and is used in over 3 million apps.
CocoaPods can help you scale your projects elegantly.

* **[Infinite Scroll](https://www.raywenderlich.com/5786-uitableview-infinite-scrolling-tutorial)** - Infinite scrolling allows users to load content continuously, eliminating the need for pagination.
The app loads some initial data and then adds the rest of the information when the user reaches the bottom of the visible content.

* **[Alamofire](https://github.com/Alamofire/Alamofire)** - We communicate with server through API requests. API end points and communication format will be decided later.
**Alamofire** is an HTTP networking library written in Swift. It will be used as the http tools in this project.

### 2. Instagram Project Marking Guide


##### 2.1 Errors are treated correctly
refer to the [language guide of swift](https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html) for error handling in swift

##### 2.2 Register and login screen
* Instagram style - refer to instagram sign up and login UI
* Don't need to do the third-party login and phone number or email sign up
* Send API Post request for sign up
* When user successfully sign up, save user info into Core Data
* Send API Post request for login
* When user logs out and want to login in again, pre-occupy username and password fields if user checked 'remember password' before (read from Core Data)

##### 2.3 Functional Tab Bar at bottom of screen with icons
Done

---
#### User Feed

##### 2.4 User Feed - Scroll through photos and comments
* Instagram style - refer to instagram photos and comments UI
* Send API Get requests and apply infinite scroll

##### 2.5 Used Feed - Like a photo and display users who liked a photo in the feed
* Instagram style - refer to instagram Like mechanism
    * if the use hasn't liked this photo, fill the Heart icon will red color when user touch on it
    * if the use has liked this photo, make the Heart icon back to hollow again
* Navigate to a new view to show who liked a photo (can use navigation view controller)
    * In the new view, refer to the Instagram UI to show the list of people, don't need to include the 'Follow' buttons
    * Send API Get requests and apply infinite scroll

##### 2.6 Used Feed - Leave a comment
* Instagram style - refer to instagram comment UI
* Send API Post requests to commit comment

##### 2.7 Used Feed - Sort by both date/time and location
* Sort button can be put at the top right corner of the header, or have better option
* Send API Get requests for different sorting strategy

---
#### Discover

##### 2.8 Discover - Search for Users
* Instagram style - refer to instagram search UI
    * search bar at the top of the screen
    * when the search bar is touched, display suggested users to follow as a list below the search bar
* When user change the input value, send API Get request to get all corresponding users to this input value
* When user touch on a particular searched user, show the profile of that user with a 'Follow' button as Instagram does [can be done later]

##### 2.9 Discover - Display suggested users to follow
* When user touch the search bar, send API Get request to get all the suggested users
* Display all the suggested users as a list below the search bar
* When user touch on a particular suggested user, show the profile of that user with a 'Follow' button as Instagram does [can be done later]

##### 2.10 Discover - Algorithm to suggest users
Backend jobs to do

---

#### Photo
When uer touch photo icon on the tab bar, let user select whether take the photo from camera or select the photo from album

Use a navigation view controller to go through all the process before uploading

##### 2.11 Photo - Take a photo with camera while providing flash options
[UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller)

##### 2.12 Photo - Change brightness and contrast
[Core Image](https://developer.apple.com/documentation/coreimage)

##### 2.13 Photo - Crop a photo
Have a look at [TOCropViewController](https://github.com/TimOliver/TOCropViewController)

##### 2.14 Photo - Apply at least 3 different filters
[Core Image](https://developer.apple.com/documentation/coreimage)

Can check usage from this [link](https://www.raywenderlich.com/2305-core-image-tutorial-getting-started).

##### 2.15 Photo - Upload photo
* Send API Post request with image in Base64 encoding
* Store post information into Core Data as well

---
#### Activity Feed

##### 2.16 Activity Feed - Display users following that liked photos or started following user
* Instagram style - refer to instagram **Following** UI
* Send API Get requests and apply infinite scroll

##### 2.17 Activity Feed - Display activity of users that current user are following
* Instagram style - refer to instagram **You** UI
* Send API Get requests and apply infinite scroll

---

#### Profile

##### 2.18 Profile - Display stats on posts, followers and following, profile pic
* Instagram style - refer to upper part of instagram Profile UI
* It is better to allow user to change their avatar

##### 2.19 Profile - Display all user photos uploaded
* Instagram style - refer to lower part of instagram Profile UI
* Don't need to include all the viewing method, just grid view all the photos with appropriate ratio
* Fetch data directly from Core Data

---

##### 2.20 Bluetooth or WiFi Adhoc Feature - In Range Swiping, e.g. Swipe photos to friends nearby that they can view on feed with an "In Range" tag
[MultipeerConnectivity](https://developer.apple.com/documentation/multipeerconnectivity)

##### 2.21 Network - Implement a server for communications or retrieve data from actual Instagram API
Backend jobs to do

##### 2.22 Code Quality
Will be checked later, better to add appropriate comment while coding
