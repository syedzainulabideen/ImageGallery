## ✨ Case Study:  Image Gallery ✨ 
Below is the brief overview of the the 'Image Gallery' application. As required,  below four points were kept in mind while designing the application.
- Architecture
- Scalability
- Intuitive UX
- Stability

### Architecture
For architecture point of view, I've design the proposed application using MVVM design pattern.
    
- View: Includes two main view, ```GalleryListingView``` and ```GalleryImageDetailView``` that shows the gallery searched list and then selected image details respectively.
- View Model: Includes only View model for the application. That is responsible for the ```Request building```, ```API calling```, ```Response handling```, ```Pagination``` and ```Populating images list``` through reactive combine framework.
- Model: Includes model structs based on the raw response from API.
    
### Scalibility
- As Application is based on three main module, Views, Networking, Caching. Each module is very much independent for its working.
- Image Listing view accept the list of ```Presentable``` objects, that is a protocl that required to have a url string and valid identifier for single resource. 
```swift
    protocol Presentable {
        var urltoPresent:String { get }
        var uniqueIdentifier:Int? { get }
    }
```
- Networking class ```ServiceManager``` required only response object type and full generated request object to process. We can change underlying framework for networking calling anytime.
- Same, Currently caching is being managed by iOS's chaching classes ```NSCache```. Which can be replaced by our own caching mechanism.
```swift
    class ImageCacheManager: NSObject, NSCacheDelegate {
        static let shared = ImageCacheManager()
        var imageCache = NSCache<NSString, NSData>()
        
        private override init() { }
        
        func addImage(for urlValue:String, image:NSData) {
            imageCache.setObject(image, forKey:NSString(string: urlValue))
        }
        
        func getCachedImage(for urlValue:String) -> NSData? {
            return imageCache.object(forKey: NSString(string: urlValue))
        }
        
        func clearupCache() {
            imageCache.removeAllObjects()
        }
    }

```


### Intuitive UX
- Adding 1 sec debounce mechanism that make sure if user hold typing for at least one second to send API call.
- Cache managment to images while user scroll to next pages after searching any keyword. Cache is being clear for every new search, so that memory won't explode for the application.
- added concurrency to load images async, so that User won't feel glicht while scrolling.
- pre loaded the images list with Pexel's curated images.

### Stability

- For stability point of view, Unit tests were implemented for the major functionality of the application.
- ```ImageLoaderTests``` includes test cases for getting valid image data, checking invalid url and converting response data to valid image.
- ```ServiceManagerTests``` includes test cases for checking unauthorized access and getting valid number of images from Pexel's API.
- ```ImageCacheManagerTests``` includes test cases for testing caching mechanism by accessing cache with valid chaced url and invalid url as well.


### Design Patterns

- Singleton: Used for Cache manager.
- Builder: Used to build network request.
```swift
    RequestBuilder()
        .httpMethod(.get)
        .withType(.image)
        .authroizationValue(AppComponents.Strings.keyAPI)
        .queryParam([
            "query":searchString,
            "per_page": "20",
            "page": "\(currentPage)"
        ])
        .build().request
```
- Strategy: Used to manage themes for application.

### Screenshots

[![Simulator-Screen-Shot-i-Phone-12-2021-03-18-at-22-02-37.png](https://i.postimg.cc/mrqqjKSx/Simulator-Screen-Shot-i-Phone-12-2021-03-18-at-22-02-37.png)](https://postimg.cc/LqtN6C7v) [![Simulator-Screen-Shot-i-Phone-12-2021-03-18-at-22-03-04.png](https://i.postimg.cc/RVsTwKRy/Simulator-Screen-Shot-i-Phone-12-2021-03-18-at-22-03-04.png)](https://postimg.cc/9r9Th4sY)
