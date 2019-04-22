# TwitterClient

## Motivation
I created this app to demonstrate how I write apps using the MVC architecture, and that MVC doesn't result in "Massive View Controller", if done correctly. I have seen and written different architectures, like MVVM and Viper, and heard developers speak of how they are "superior". The problem is that most justifications for using these alternative architectures are predicated on a misunderstanding of what MVC is in Cocoa Touch.

### Model View Controller
Before we start talking about the confusion around MVC, let's go over the basics. The basic idea of MVC can be summed up with one image:

![MVC Diagram](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Art/model_view_controller_2x.png)

You can see that Models cannot talk to Views, and Controllers mediate the flow of data between the Model and the View, as well as user interaction from the View to the Model. Pretty basic. 

### The Confusion
For a while, I have been amazed at how few iOS developers I encounter architect their apps with MVC. Most cite "Massive View Controller" as the biggest reason to adopt an alternative architecture. The idea of "Massive View Controller" is that it encourages you to put almost all logic in your `UIViewController` subclasses, which leads to bloat, making your view controllers less maintainable and testable. The most common definition of MVC I hear is something like this:

> MVC stands for Model View Controller, where models are your data objects, view is your `UIView`, and controller is your `UIViewController`.
 
While this answer is valid, in that `UIViewController` can be categorized as a controller, this is not *only* definition, or even the *best* definition. I have seen countless articles proposing a "new way" of writing iOS apps which uses this this definition of MVC in iOS.

This has always confused me, because I have never used this definition of MVC in my apps. Using `UIViewController` as the place for almost all of my code has never been the way I write my view controllers. Furthermore, I had never seen this in any documentation, only in blogs and articles circulated in the iOS community. Does this definition come from another platform or language? Where in Apple's documentation is this definition found?

This sentence in Apple's [View Controller Programming Guide for iOS](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/) sums it up: 
> "Because they play such an important role in your app, view controllers are at the center of almost everything you do". 
After reading this sentence, I understood why I see this misunderstanding everywhere. *No wonder* iOS devs were running into "Massive View Controller", Apple is **literally** telling us to write them! 

Where the confusion begins, I believe, is at the Controller. `UIViewController` is a controller object. The problem comes from the definition above, that they are the *center or almost everything you do*. How does that influence how we view MVC?
With this definition, it is easy to understand MVC in a completely different way, and I believe this is what has happened within the iOS community.

We have moved from controllers mediating the flow of data between models and view, to controllers containing **everything** that is not a model or a view. With this understanding, your networking, database queries, table/collection view data source methods, and business logic could all go in `UIViewController`. Viewing `UIViewController` as the *center of almost everything we do* makes it easy to for the size of your view controllers to get out of hand very quickly, now known as "Massive View Controller".

### The Solution
Let's go back to an older, more clear definition of what a controller is in Apple's MVC architecture. The photo above comes from [this article](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/MVC.html). Here is the section explaining controller objects, see if you can spot a difference:

> A controller object acts as an intermediary between one or more of an application’s view objects and one or more of its model objects. Controller objects are thus a conduit through which view objects learn about changes in model objects and vice versa. Controller objects can also perform setup and coordinating tasks for an application and manage the life cycles of other objects.

> **Communication**:  A controller object interprets user actions made in view objects and communicates new or changed data to the model layer. When model objects change, a controller object communicates that new model data to the view objects so that they can display it.

I want you to notice how different this definition of a controller is than Apple's newer definition of `UIViewController`. While Apple's newer definition is vague and broad, this older definition is narrow and specific. A controller is an intermediary, a conduit to mediate between objects.

Using this older definition of a controller, "Massive View Controller" is not a problem. We have reigned in the wide range of responsibilities, and given our controllers a clear and specific role. So ask yourself, given this definition of a controller, should your view controllers make network calls? The answer is a very clear **no**. What about writing data from the network to a database? **No**.

So where do these types of operations belong, now that we have narrowed the scope of `UIViewController`? We can answer that by reading a more detailed description of controller objects [here](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/ControllerObject.html#//apple_ref/doc/uid/TP40008195-CH11-SW1).

#### Types of Controllers
Did you know `UIViewController` is not the *only* type of controller we can use in MVC? There are three different types of controllers: coordinating controllers, view controllers, and  mediating controllers. You can have more than one *type* of controller in your MVC stack! MVC doesn't mean only *1* controller per screen. I always have at least one additional coordinating controller with each `UIViewController`. 

Let's look at the different types of controllers, their roles, and how we can use them alongside `UIViewController`. It is important to not that these definitions are high level, and there is some overlap.

##### Coordinating Controllers
The most basic definition can be summarized as follows:

> An object which coordinates actions or passes information between different components

Some examples of this would be:

* Responding to delegation messages and observing notifications
* Responding to action messages (which are are sent by controls such as buttons when users tap or click them)
* Establishing connections between objects and performing other setup tasks, such as when the application launches
* Managing the life cycle of “owned” objects

It is important to note that some of these examples sound like `UIViewController`, because, as the docs point out, they can "subsume the role of a coordinating controller". Notice that it *can subsume the **role***. This is important. You can write your view controllers to take on the role of a coordinating controller, but it is **not** a coordinating controller. Furthermore, I believe you *should not* write your view controllers in this way.

So how can we use coordinating controllers to lighten our view controllers? We can look at Apple's frameworks for some inspiration. It's important to note that the name of object doesn't need to contain the word "Controller".

###### NSFetchedResultsController
`NSFetchedResultsController` is a great example of using coordinating controllers to pass information between core data and and another object. That other object could be a view controller, or even your UI (you can use them as the data source for your table views).

###### UIPresentationController
`UIPresentationController` is defined as "as object that manages the transition animations and the presentation of view controllers onscreen". Custom view controller presentations involve a few different objects, and `UIPresentationController` acts as the *coordinator* between the animator objects. For example, you can use `UIPresentationController` to dim the background during an animation, using the transition callbacks provided by the class.

##### View Controllers
Here is a more in-depth definition of `UIViewController` from Apple's older documentation:

> IN UIKit, a view controller manages a view displaying a screenful of content; it keeps a reference to this view and may create or load it from a nib file. The controller manages the presentation of this view and the transition to any subsequent view in the app. (In most cases, the next view slides in from the right.) The navigation bar and the tab bar, and all their associated presentation behavior, are managed and implemented by view controller objects. View controllers can also display modal views, respond to low-memory warnings, and rotate views when the orientation changes.

While Apple has added more methods and capabilities to `UIViewController`, this is the essential role of `UIViewController`. Apple's naming is confusing, since it has both "View" and "Controller" in the name, leading to some debate about whether they are the V or the C part of MVC.  