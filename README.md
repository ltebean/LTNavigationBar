![LTNavigationbar](https://cocoapod-badges.herokuapp.com/v/LTNavigationBar/badge.png)

## Purpose
It is hard to change the appearance of UINavigationBar dynamically, so I made this lib to make the job easy.


## Demo
#### 1. Changing the background color:
![LTNavigationbar](https://raw.githubusercontent.com/ltebean/LTNavigationBar/master/images/demo.gif)


#### 2. Making navigation bar scroll along with a scroll view:
![LTNavigationbar](https://raw.githubusercontent.com/ltebean/LTNavigationBar/master/images/demo2.gif)

## Usage

First, import this lib:
```objective-c
#import "UINavigationBar+Awesome.h"
```

The category includes lots of method that helps to change UINavigationBar's appearance dynamically:
```objective-c
@interface UINavigationBar (Awesome)
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;
@end
```

You can call the various setter wherever you want, like:
```objective-c
[self.navigationController.navigationBar lt_setBackgroundColor:[UIColor blueColor]];
```

And usually in `viewWillDisappear`, you should call this method to avoid any side effects:
```objective-c
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}
```

See the example for details~ 