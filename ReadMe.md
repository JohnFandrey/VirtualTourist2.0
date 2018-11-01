**Virtual Tourist**

**Introduction**

Virtual Tourist is an iOS app that allows users to drop pins on a map.  When the pins are tapped the user will be shown images from Flickr that are associated with the location of the dropped pin.  

**Running Virtual Tourist**

To run Virtual Tourist open the VirtualTourist.xcodeproj file in Xcode and then build and run the project.  

**Using Virtual Tourist**

_App Launch_

Virtual Tourist tracks if a particular launch of the app is the first launch of the app.  On the first launch an alert controller is displayed that provides the user with instructions for using the app.  

_The Map View_

The Map View displays a map on which pins can be placed. If a user presses on the map for one second then a pin will be dropped at the location of the press.  If the edit button in the top right corner of the app is pressed a text box will appear at the bottom of the map view.  The text will read 'Tap Pins to Delete'.  If a pin is tapped while the edit button is activated then the tapped pin will be deleted.  Once the edit button is pressed the text of the 'Edit' button will read 'Done'  If the user presses the edit button while it reads 'Done' the text box at the bottom of the app will disappear and the user will no longer be able to delete pins by tapping them.  

If the user taps a pin while the edit button reads 'Edit' then, the user will be taken to the Collection View screen.  

_Collection View Screen_

The Collection View screen shows the user images retrieved from Flickr that are associated with the location of the dropped pin.  The Collection View screen also has a map view that shows the user a more precise location of the pin that was tapped.  The Collection View Screen has a button 'New Collection'.  If the user presses 'New Collection' then all the photos will be removed and new photos will be retrieved from Flickr.  If the user taps any of the photos, the tapped photos will be removed from the collection.  There is also a 'back' button in the top left corner of the collection view.  Tapping the 'back' button takes the user back to the Map View.  

On the first use of Virtual Tourist when the Collection View is displayed an alert message will be displayed that provides the user with instructions for using the Collection View.  

**Conclusion**

Thanks for trying out VirtualTourist.  I hope you enjoy the app.  
