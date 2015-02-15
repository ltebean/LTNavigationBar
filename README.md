It is hard to change the background color of UINavigationBar along with the status bar dynamically, so I made this lib to make the job easy.

![LTNavigationbar](https://raw.githubusercontent.com/ltebean/LTNavigationbar/master/demo.gif)

## Usage

Step one:
```objective-c
#import "UINavigationBar+BackgroundColor.h"
```

Step two: update the background color wherever you want
```objective-c
[self.navigationController.navigationBar useBackgroundColor:[UIColor blueColor]];
```

Step three: in `viewWillDisappear` reset the nagivation bar
```objective-c
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar reset];
}
```

See the example for details~ 