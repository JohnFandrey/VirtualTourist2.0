//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by John Fandrey on 7/6/18.
//  Copyright © 2018 John Fandrey. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let dataController = DataController(modelName: "VirtualTourist")
    
    // The function below 'checkIfFirstLaunch' was adapted from the Udacity iOS Developer Nanodegree material, specifically, Lesson 1 of the Data Persistence Course which can be found at https://classroom.udacity.com/nanodegrees/nd003/parts/e97f6879-7f09-42cf-81a2-8ee1a1e9958e/modules/307104883375460/lessons/7708131740/concepts/988f362b-d572-453f-9592-c5e6ea687006.
    
    func checkIfFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
        } else {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            UserDefaults.standard.set(37.69, forKey: "latitude")
            UserDefaults.standard.set(-97.3375, forKey: "longitude")
            UserDefaults.standard.set(69.97848, forKey: "latitudeDelta")
            UserDefaults.standard.set(57.46729, forKey: "longitudeDelta")
            UserDefaults.standard.set(true, forKey: "presentInfo")
            UserDefaults.standard.set(true, forKey: "presentCollectionInfo")
            UserDefaults.standard.synchronize()
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataController.load()       // This line loads the persisted data for the app. 
        let navigationController = window?.rootViewController as! UINavigationController
        let mapViewController = navigationController.topViewController as! MapViewController
        mapViewController.dataController = dataController
        checkIfFirstLaunch()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.saveViewContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // The line below saves changes in the application's managed object context before the application terminates.
        self.saveViewContext()
    }
    
    // The function saveViewContext was provided in the Udacity Mooskine app.  The function has been used here to save the viewContext when the app moves to the background and when the application will terminate. 
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }

}

