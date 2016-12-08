![LTNavigationbar](https://cocoapod-badges.herokuapp.com/v/LTNavigationBar/badge.png)


# swift 3.0 version 


## Purpose
It is hard to change the appearance of UINavigationBar dynamically, so I made this lib to make the job easy.


## Demo
#### 1. Changing the background color:
![LTNavigationbar](https://raw.githubusercontent.com/ltebean/LTNavigationBar/master/images/demo.gif)


#### 2. Making navigation bar scroll along with a scroll view:
![LTNavigationbar](https://raw.githubusercontent.com/ltebean/LTNavigationBar/master/images/demo2.gif)

## Usage

- drag UINavigationBarExtension.swift file to project

The Extension includes lots of method that helps to change UINavigationBar's appearance dynamically:

```swift
func lt_setBackgroundColor(backgroundColor: UIColor)
func lt_setElementsAlpha(alpha: CGFloat)
func lt_setTranslationY(translationY: CGFloat)
func lt_reset()
```

You can call the various setter wherever you want, like:

```swift
navigationController.navigationBar.lt_setBackgroundColor(.blueColor)
```

And usually in `viewWillDisappear`, you should call this method to avoid any side effects:

```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController.navigationBar.lt_reset()
}
```
 