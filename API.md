#APIs Specification
#### 0. Preliminary
* The host name of the API server is **https://comp90018.herokuapp.com**
* Therefore, the full API request url of, for example, the user register, is **https://comp90018.herokuapp.com/api/user/register**
* For the format of time, please refer to Instagram app

---

#### 1. User Register
```POST /api/user/register```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "tizhou",
        "name": "ti zhou",
        "password": "123456"
    }
```

**Server**

* if username is already in the db, send response:

```javascript
    {
        "status": "rejected",
        "log": "user already exist"
    }
```

* if register is validated, send response:

```javascript
    {
        "status": "accepted"
    }
```
---

#### 2. User Login
```POST /api/user/login```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "password": "123456"
    }
```

**Server**

* if username already in the db, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* if username and password doesn't match, send response:

```javascript
    {
        "status": "rejected",
        "log": "incorrect password"
    }
```

* if username and password matches, send response:

```javascript
    {
        "status": "accepted",
        "data": {
                    "avatar": "#url_to_avatar"
                }
    }
```

---

#### 4. Get User Feed

```GET /api/userfeed```

**Client**

client send the following data with the API request:

```javascript
    {
      "username": "ti zhou",
      "sort": "location/time/",
      "longitude": 101.112,
      "latitude": 60.232
    }
```

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* if user exists, gather photos of all users that the user follows and send response:

```javascript
    {
        "status": "accepted",
        "data": [{
                    "id": 1,
                    "avatar": "#url_to_avatar",
                    "username": "haitian he",
                    "text": "it's a good one",
                    "location": "west melbourne",
                    "image": "#url_to_image",
                    "height": 100,
                    "width": 200,
                    "number_of_likes": 12,
                    "number_of_comments": 10,
                    "like": true,
                    "first_comment": {
                                        "username": "ti zhou",
                                        "comment": "it's good"
                                     },
                    "time": "10 HOURS AGO"
                }]
    }
```

* if _sort_ field in data is set, send back response array in indicated order. Otherwise, send response array in time descendent order as default.

---


#### 4. Get Users liked a photo

```GET /api/userfeed/like```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "phto_id": 2
    }
```

* _search_ field is the characters user types in the text input

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* otherwise, gather all users who liked the photo with given photo_id and send response:

```javascript
    {
        "status": "accepted",
        "data": [{
                    "avatar": "url_to_avatar",
                    "username": "haitianhe",
                    "name": "haitian he",
                    "following_him": true/false,
                    "get_followed": true/false,
                }]
    }
```

* _following\_him_ and _get\_followed_ has the same behaviour as in 12. Get Profile Status

---


#### 5. User like Photo

```POST /api/userfeed/like```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "photo_id": 1
    }
```

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* if user exist, switch the user _like_ condition of that photo in db, then send response:

```javascript
    {
        "status": "accepted"
    }
```

---

#### 6. Get Photo Comments

```GET /api/userfeed/comment```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "photo_id": 1
    }
```

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* otherwise, gather all comments on that photo and send response:

```javascript
    {
        "status": "accepted",
        "data": [{
                    "username": "ti zhou",
                    "avatar": "url_to_avatar",
                    "text": "it's good",
                    "time": "2d"
                }]
    }
```

---

#### 7. Comment Photo

```POST /api/userfeed/comment```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "photo_id": 1,
        "comment": "this is a new comment"
    }
```

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* if user exist, save the comment of the user on the photo in db and send response:

```javascript
    {
        "status": "accepted"
    }
```

---

#### 8. Search Users

```GET /api/discover/search```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "search": "h"
    }
```

* _search_ field is the characters user types in the text input

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* if _search_ is empty string, do nothing
* otherwise, gather all users whose username contains the string in _search_ field and send response:

```javascript
    {
        "status": "accepted",
        "data": [{
                    "avatar": "url_to_avatar",
                    "username": "haitianhe",
                    "name": "haitian he"
                }]
    }
```

---

#### 9. Get suggested users

```GET /api/discover/suggested```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou"
    }
```

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* if user exist, apply suggestion algorithm to gather suggested users for the user and send response:

```javascript
    {
        "status": "accepted",
        "data": [{
                    "avatar": "url_to_avatar",
                    "username": "haitianhe",
                    "name": "haitian he"
                }]
    }
```

---

#### 10. Upload photo

```POST /api/photo```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "photo": "Base64_format_photo_string",
        "height": 100,
        "width": 200,
        "location": "North Melbourne",
        "longitude": 101.112,
        "latitude": 60.232,
        "caption": "look at this picture",
    }
```

* _photo_ field is a string, which is the photo data in Base64 format

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* if user exist, save the photo in the users' photo table and send response:

```javascript
    {
        "status": "accepted"
    }
```

---

#### 11. Get Activity Feed

```GET /api/activityfeed```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "type": "Following/You"
    }
```

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* if _type_ field is "Following", send response:

```javascript
    {
        "status": "accepted",
        "data": [{
                    "avatar": "url_to_avatar",
                    "first_username": "haitian he",
                    "type": "liked",
                    "image_id":[233, 409],
                    "image": ["image1_url","image2_url"],
                    "time": "3h",
                    "image_owner": ["tizhou", "haitianhe"]
                },{
                    "avatar": "url_to_avatar",
                    "first_username": "haitian he",
                    "type": "started following",
                    "second_username": ["tizhou","huahua"],
                    "time": "3h",
                }]
    }
```

  * The upper limit of image number is 7.
  * The upper limit of second_usrname number is 7.
  * if the length of image_owner is longer than 1, ignore

* if _type_ field is "You", send response:

```javascript
    {
        "status": "accepted",
        "data": {
            "Today": [{
                        "avatar": "url_to_avatar",
                        "first_username": "haitian he",
                        "type": "liked",
                        "image_id":[233,409],
                        "image": ["image1_url","image2_url"],
                        "time": "3h",
                     }],
            "This Week": [{
                            "avatar": "url_to_avatar",
                            "first_username": "haitian he",
                            "type": "started following",
                            "time": "3d",                     
                         }],
            "This Month": [{
                            "avatar": "url_to_avatar",
                            "first_username": "haitian he",
                            "type": "started following",
                            "time": "3w",                                          
                          }],
            "Earlier": [{					
            				"avatar": "url_to_avatar",
            				"first_username": "haitian he",
            				"type": "liked",
				 			"image_id":[233,409],
				 			"image": ["image1_url","image2_url"],
				 			"time": "3mon",  
                       }]
        }
    }
```
  * if the *type* is "start following", displayed text should be "start following you"
  * if the *type* is "liked", displayed text should be "liked your post(s)"

---

#### 12. Get Profile Stats

```GET /api/profile```

**Client**

client send the following data with the API request:

```javascript
    {
        "my_username": "tizhou",
        "profile_username": "haitianhe",
    }
```

**Server**

* if either user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* otherwise, server gather the number of posts, followers and followings of the user and send response:

```javascript
    {
        "status": "accepted",
        "data": {
            "avatar": "#url_to_avatar",
            "following_him": true/false,
            "get_followed": true/false,
            "posts": 1,
            "followers": 2,
            "following": 3,
            "photos": ["image1_url", "image2_url", "image3_url", "image4_url"],
            "id": [12, 23, 45, 32]
        }
    }
```
* _photos_ field can be an empty array if the user didn't post photos. There is no up limit of the number of photos.

---

#### 13. Follow

```POST /api/profile/follow```

**Client**

client send the following data with the API request:

```javascript
    {
        "my_username": "ti zhou",
        "follow_username": "haitianhe"
    }
```

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* otherwise, server update _my_username_ following _follow_username_ and send response:

```javascript
    {
        "status": "accepted",
    }
```

---

---

#### 14. Photo Detail

```GET /api/photo/detail```

**Client**

client send the following data with the API request:

```javascript
    {
        "username": "ti zhou",
        "photo_id": 12
    }
```

**Server**

* if user doesn't exist, send response:

```javascript
    {
        "status": "rejected",
        "log": "user doesn't exist"
    }
```

* otherwise, server send response:

```javascript
    {
        "status": "accepted",
        "data": {
                    "id": 1,
                    "avatar": "#url_to_avatar",
                    "username": "haitian he",
                    "text": "it's a good one",
                    "location": "west melbourne",
                    "image": "#url_to_image",
                    "height": 100,
                    "width": 200,
                    "number_of_likes": 12,
                    "number_of_comments": 10,
                    "like": true,
                    "first_comment": {
                                        "username": "ti zhou",
                                        "comment": "it's good"
                                     },
                    "time": "10 HOURS AGO"
                }
    }
```
