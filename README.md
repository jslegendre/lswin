# lswin
A simple macOS CLI tool that lists current window information. 

### Usage

```
USAGE: lswin [--verbose] [--all] [--process <process>] [--no-menubar-items]

OPTIONS:
  -v, --verbose           Print additional window information
  -a, --all               Show information for all windows (including offscreen)
  -p, --process <process> Only show windows belonging to process named <process> (case insensitive)
  --no-menubar-items      Filter out menubar items
  -h, --help              Show help information.
```

### Sample Output
```
% lswin
127    Terminal                      	Terminal                                       
219    Activity Monitor              	Activity Monitor              
314    Release                       	Finder                        
509    Console                       	Console                                              
633    Trash                         	Finder    

% lswin -v
+- 127
 |+- Terminal
 |+- Terminal
 |+- pid 3135
 |+- Origin: (156.00, 159.00)
 |+- Size: (949.00, 455.00)
 |+- Is On Screen: Yes
 |+- Is Menu Item: No
 
 +- 314
 |+- Release
 |+- Finder
 |+- pid 1978
 |+- Origin: (487.00, 75.00)
 |+- Size: (920.00, 464.00)
 |+- Is On Screen: Yes
 |+- Is Menu Item: No

 +- 633
 |+- Trash
 |+- Finder
 |+- pid 1978
 |+- Origin: (382.00, 263.00)
 |+- Size: (875.00, 456.00)
 |+- Is On Screen: Yes
 |+- Is Menu Item: No
```

### Installing / Removing
To make `lswin` available globally from `/usr/local/bin/` you can run: `swift run install`.

To uninstall: `swift run uninstall`

### Todo:
I just whipped this up pretty quickly to speed up debugging when using `CoreGraphics` and `Accessibility` APIs. I'm sure a lot more could be added besides the list below. PRs are open :)

- Better output formatting
- More window information
