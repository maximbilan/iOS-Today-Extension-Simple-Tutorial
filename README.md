# iOS Today Extension Simple Tutorial

I would like to tell a little bit about how to create a simple Today Widget for iOS 8 and higher. We can find a lot of application in the store with widgets, really different widgets, such as weather, currencies, quick buttons for tracking something, location, etc. Example from my application, which displays currencies:

![alt tag](https://raw.github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial/master/screenshots/1.png)

It’s not separated application, which you can submit to the store, it’s extension of your application, and you can’t submit only the widget.

Let’s start. First of all, add a new target to your project:

![alt tag](https://raw.github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial/master/screenshots/2.png)

Choose options:

![alt tag](https://raw.github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial/master/screenshots/3.png)

And create a scheme:

![alt tag](https://raw.github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial/master/screenshots/4.png)

Now you have _MainInterface.storyboard_ and _TodayViewController.swift_. The main controller implements _NCWidgetProviding_ protocol. In this protocol we have two methods:

```swift
// If implemented, the system will call at opportune times for the widget to update its state, both when the Notification Center is visible as well as in the background.
// An implementation is required to enable background updates.
// It’s expected that the widget will perform the work to update asynchronously and off the main thread as much as possible.
// Widgets should call the argument block when the work is complete, passing the appropriate ‘NCUpdateResult’.
// Widgets should NOT block returning from ‘viewWillAppear:’ on the results of this operation.
// Instead, widgets should load cached state in ‘viewWillAppear:’ in order to match the state of the view from the last ‘viewWillDisappear:’, then transition smoothly to the new data when it arrives.
@available(iOS 8.0, *)
optional public func widgetPerformUpdateWithCompletionHandler(completionHandler: (NCUpdateResult) -> Void)

// Widgets wishing to customize the default margin insets can return their preferred values.
// Widgets that choose not to implement this method will receive the default margin insets.
optional public func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets
```

In the first method you need to fetch a new data if you have, and you need to call a completion handler with three possible values: _NewData_, _NoData_, _Failed_. And widget will be know, will update UI or use old snapshot.

In the second method Apple gives a chance to change margins. By default Today Widget has left margin, you can see in default Apple applications, such as Calendar, Stocks.

![alt tag](https://raw.github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial/master/screenshots/5.png)

For example:

```swift
func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
    return UIEdgeInsetsZero
}
```

Let’s create a simple extension. Please, add the _TableView_ to interface and set up an outlet.

![alt tag](https://raw.github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial/master/screenshots/6.png)

For the static height of the view you need to set up _preferredContentSize_:

```swift
self.preferredContentSize.height = 200
```

Implementation of loading data, for example from _plist_:

```swift
func loadData() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
        self.data.removeAll()
        
        if let path = NSBundle.mainBundle().pathForResource(“Data”, ofType: “plist”) {
            if let array = NSArray(contentsOfFile: path) {
                for item in array {
                    self.data.append(item as! NSDictionary)
                }
            }
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
```

And of course the simple implementation of _UITableView_:

```swift
func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
}

func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCellIdentifier", forIndexPath: indexPath)

    let item = data[indexPath.row]
    cell.textLabel?.text = item["title"] as? String
    cell.textLabel?.textColor = UIColor.whiteColor()

    return cell
}
```

And finally we get the result:

![alt tag](https://raw.github.com/maximbilan/iOS-Today-Extension-Simple-Tutorial/master/screenshots/7.png)

Full code you can find in this repository. Happy coding!
