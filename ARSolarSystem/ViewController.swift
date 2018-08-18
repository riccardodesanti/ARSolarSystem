//
//  ViewController.swift
//  ARSolarSystem
//
//  Created by Riccardo De Santi on 18/08/2018.
//  Copyright © 2018 Riccardo De Santi. All rights reserved.
//

import UIKit
import ARKit

struct MotionParams {
    let x: CGFloat
    let y: CGFloat
    let z: CGFloat
    let duration: TimeInterval
}

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let actualScreenBounds = UIScreen.main.bounds
    
    let sheetView =  UIView()
    let sheetTitle = UILabel()
    let sheetImageView = UIImageView()
    let sheetText = UILabel()
    let sheetButton = UIButton()
    let softOpacityLayer  = UIView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let solarSystem = SCNScene()
        
        createPlanetLayer(radius: 0.11, img: #imageLiteral(resourceName: "sun"), zDelta: 0, rot: MotionParams(x: 0, y: 1, z: 0, duration: 1), rev: MotionParams(x: 0, y: 0, z: 0, duration: 1), scene: solarSystem, name: "Sun")
        createPlanetLayer(radius: 0.01, img: #imageLiteral(resourceName: "mercury"), zDelta: 0.18, rot: MotionParams(x: 0, y: 1, z: 0, duration: 3), rev: MotionParams(x: 0, y: 1, z: 0, duration: 2), scene: solarSystem, name: "Mercury")
        createPlanetLayer(radius: 0.03, img: #imageLiteral(resourceName: "venus"), zDelta: 0.28, rot: MotionParams(x: 0, y: -1, z: 0, duration: 3), rev: MotionParams(x: 0, y: 1, z: 0, duration: 4), scene: solarSystem, name: "Venus")
        createPlanetLayer(radius: 0.03, img: #imageLiteral(resourceName: "earth"), zDelta: 0.39, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.5), rev: MotionParams(x: 0, y: 1, z: 0, duration: 5), scene: solarSystem, name: "Earth")
        createPlanetLayer(radius: 0.015, img: #imageLiteral(resourceName: "mars"), zDelta: 0.49, rot: MotionParams(x: 0, y: 1, z: 0, duration: 1), rev: MotionParams(x: 0, y: 1, z: 0, duration: 7), scene: solarSystem, name: "Mars")
        createPlanetLayer(radius: 0.06, img: #imageLiteral(resourceName: "jupiter"), zDelta: 0.65, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.5), rev: MotionParams(x: 0, y: 1, z: 0, duration: 11), scene: solarSystem, name: "Jupiter")
        createPlanetLayer(radius: 0.045, img: #imageLiteral(resourceName: "saturn"), zDelta: 0.79, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.5), rev: MotionParams(x: 0, y: 1, z: 0, duration: 18), scene: solarSystem, name: "Saturn")
        createPlanetLayer(radius: 0.02, img: #imageLiteral(resourceName: "uranus"), zDelta: 0.88, rot: MotionParams(x: 0, y: -1, z: 0, duration: 0.7), rev: MotionParams(x: 0, y: 1, z: 0, duration: 35), scene: solarSystem, name: "Uranus")
        createPlanetLayer(radius: 0.02, img: #imageLiteral(resourceName: "neptune"), zDelta: 0.96, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.9), rev: MotionParams(x: 0, y: 1, z: 0, duration: 50), scene: solarSystem, name: "Neptune")
//        createPlanetLayer(radius: 0.005, img: #imageLiteral(resourceName: "pluto"), zDelta: 1.01, rot: MotionParams(x: 0, y: 1, z: 0, duration: 3), rev: MotionParams(x: 0, y: 1, z: 0, duration: 70), scene: solarSystem, name: "pluto")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        sceneView.scene = solarSystem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        UIView.animate(withDuration: 5, animations: {
            print("anim")
            self.sheetView.frame.origin.y = 0
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func createPlanetLayer(radius: CGFloat, img: UIImage, zDelta: Float, rot: MotionParams, rev: MotionParams, scene: SCNScene, name: String) {
        //Definition of  rotation ( counter-clockwise for every planet except Venus and Uranus)
        let RotationAction = SCNAction.rotateBy(x: rot.x, y: rot.y, z: rot.z, duration: rot.duration)
        let RotationLoop = SCNAction.repeatForever(RotationAction)
        
        
        //Defines and activates revolutionary motion ( with different period for each planet)
        let revolutionAction = SCNAction.rotateBy(x: rev.x, y: rev.y, z: rev.z, duration: rev.duration)
        let revolutionLoop = SCNAction.repeatForever(revolutionAction)
        
        // Planet 1 creation
        //Creation of the node/layer used for the revolutionary motion ( this node rotates around its own y axis)
        let planetLayer = SCNNode()
        planetLayer.position = SCNVector3(0,0,0)
        
        // Creation of the Sphere Objects and its relative node later added to the layer just created.
        let planet = SCNSphere(radius: radius)
        let planetMaterial = SCNMaterial()
        planetMaterial.diffuse.contents = img
        planet.materials = [planetMaterial]
        let planetNode = SCNNode(geometry: planet)
        planetNode.name = name
        planetNode.position = SCNVector3(0,0,zDelta)
        planetLayer.addChildNode(planetNode)
        
        //Activates rotational motion ( same for each planet for semplification purposes )
        planetNode.runAction(RotationLoop)
        planetLayer.runAction(revolutionLoop)
        
        //Creates moon and makes it rev around the earth
        if (name == "Earth") {
            //Definition of  rotation ( counter-clockwise for every planet except Venus and Uranus)
            let RotationActionSatellite = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 2.8)
            let RotationLoopSatellite = SCNAction.repeatForever(RotationActionSatellite)
            
            
            //Defines and activates revolutionary motion ( with different period for each planet)
            let revolutionActionSatellite = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 3)
            let revolutionLoopSatellite = SCNAction.repeatForever(revolutionActionSatellite)
            
            let satelliteLayer = SCNNode()
            satelliteLayer.position = SCNVector3(0,0,0)
            
            let satellite = SCNSphere(radius: 0.006)
            let satelliteMaterial = SCNMaterial()
            satelliteMaterial.diffuse.contents = #imageLiteral(resourceName: "moon")
            satellite.materials = [satelliteMaterial]
            let satelliteNode = SCNNode(geometry: satellite)
            satelliteNode.name  = "Moon"
            satelliteNode.position = SCNVector3(0,0,0.04)
            satelliteLayer.addChildNode(satelliteNode)
            
            //Activates rotational motion ( same for each planet for semplification purposes )
            satelliteNode.runAction(RotationLoopSatellite)
            satelliteLayer.runAction(revolutionLoopSatellite)
            
            //Makes it rev around the earth
            planetNode.addChildNode(satelliteLayer)
        }
        
        scene.rootNode.addChildNode(planetLayer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let tappedView = sender.view as! SCNView
        let touchLocation = sender.location(in: tappedView)
        let hitTest = tappedView.hitTest(touchLocation, options: nil)
        if !hitTest.isEmpty {
            let result = hitTest.first!
            let name = result.node.name!
            print(name)
            var text = String()
            var img = UIImage()
            switch name {
            case "Mercury":
                text = "Orbital period(d):  88\nRotation period(h):  1407.6\nDiameter(km):  4879 \nGravity(m/s2):  3.7"
                img = #imageLiteral(resourceName: "mercury_img")
            case "Venus":
                text = "Orbital period(d):  224.7\nRotation period(h):  -5832.5\nDiameter(km):  12104 \nGravity(m/s2):  8.9"
                img = #imageLiteral(resourceName: "venus_img")
            case "Earth":
                text = "Orbital period(d):  365.2\nRotation period(h):  23.9\nDiameter(km):  12756 \nGravity(m/s2):  9.8"
                img = #imageLiteral(resourceName: "earth_img")
            case "Mars":
                text = "Orbital period(d):  687\nRotation period(h):  24.6\nDiameter(km):  6792 \nGravity(m/s2):  3.7"
                img = #imageLiteral(resourceName: "mars_img")
            case "Jupiter":
                text = "Orbital period(d):  4331\nRotation period(h):  9.9\nDiameter(km):  142984 \nGravity(m/s2):  23.1"
                img = #imageLiteral(resourceName: "jupiter_img")
            case "Saturn":
                text = "Orbital period(d):  10747\nRotation period(h):  10.7\nDiameter(km):  120536 \nGravity(m/s2):  9.0"
                img = #imageLiteral(resourceName: "saturn_img")
            case "Uranus":
                text = "Orbital period(d):  30589\nRotation period(h):  -17.2\nDiameter(km):  51118 \nGravity(m/s2):  8.7"
                img  = #imageLiteral(resourceName: "uranus_img")
            case "Neptune":
                text = "Orbital period(d):  59800\nRotation period(h):  16.1\nDiameter(km):  49528 \nGravity(m/s2):  11"
                img = #imageLiteral(resourceName: "neptune_img")
            case "Moon":
                text = "Orbital period(d):  27.3\nRotation period(h):  655.7\nDiameter(km):  3340 \nGravity(m/s2):  1.6"
                img = #imageLiteral(resourceName: "moon_img")
            default:
                text = "Rotation period(d):  24.47\nDiameter(km):  1392000 \nGravity(m/s2):  274"
                img = #imageLiteral(resourceName: "sun_img")
            }
            createSheetView(title: name, text: text, img: img)
        }
    }
    
    func createSheetView(title: String, text: String, img: UIImage) {
        
        sheetView.frame = CGRect( x: 0, y: actualScreenBounds.height, width: actualScreenBounds.width, height: 250)
        sheetView.backgroundColor = UIColor.white
        sheetView.layer.masksToBounds = true
        sheetView.layer.cornerRadius = 40
        sheetView.clipsToBounds = true
        view.addSubview(sheetView)
        
        sheetTitle.frame = CGRect( x: 0, y: actualScreenBounds.height + 5, width: actualScreenBounds.width, height: 40)
        sheetTitle.text = title
        sheetTitle.font = UIFont(name: "Rubik-Bold", size: 22)
        sheetTitle.textAlignment = .center
        sheetTitle.numberOfLines = 1
        sheetTitle.textColor = UIColor.darkText
        view.addSubview(sheetTitle)
        
        sheetImageView.frame = CGRect(x: 10, y: actualScreenBounds.height+55, width: (actualScreenBounds.width - 100)/2, height: (actualScreenBounds.width - 100)/2)
        sheetImageView.image = img
        view.addSubview(sheetImageView)
        
        sheetText.frame = CGRect( x: (actualScreenBounds.width/2) - 25, y: actualScreenBounds.height + 55, width: (actualScreenBounds.width - 60)/2 + 40, height: 130)
        sheetText.text = text
        sheetText.font = UIFont(name: "Rubik-Regular", size: 15)
        sheetText.textAlignment = .justified
        sheetText.setLineSpacing(lineSpacing: 2)
        sheetText.numberOfLines = 4
        sheetText.textColor = UIColor.darkText
        view.addSubview(sheetText)
        
        sheetButton.frame.size = CGSize(width: 80, height: 40)
        sheetButton.center = CGPoint(x: sheetView.center.x, y: sheetView.center.y + CGFloat(30))
        sheetButton.backgroundColor = UIColor(red: 46.0/255, green: 202.0/255, blue: 113.0/255, alpha: 1.0)
        sheetButton.layer.masksToBounds = true
        sheetButton.layer.cornerRadius = 20
        
        sheetButton.setTitle("Close", for: UIControlState())
        view.addSubview(sheetButton)
        
        
        sheetButton.addTarget(self, action: #selector(self.removeSheetView), for: .touchUpInside)
        
        self.softOpacityLayer.backgroundColor = UIColor.black
        self.softOpacityLayer.alpha = 0
        self.view.insertSubview(self.softOpacityLayer, belowSubview: self.sheetView)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
            
            self.sheetView.frame.origin.y = self.actualScreenBounds.height - 250
            self.sheetButton.frame.origin.y = self.actualScreenBounds.height - 60
            self.sheetTitle.frame.origin.y = self.actualScreenBounds.height - 245
            self.sheetImageView.frame.origin.y = self.actualScreenBounds.height - 200
            self.sheetText.frame.origin.y = self.actualScreenBounds.height - 200
            self.softOpacityLayer.alpha = 0.38
            
        }, completion: nil)
    }
    
    @objc func removeSheetView() {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: {
            
            self.sheetView.frame.origin.y = self.actualScreenBounds.height
            self.sheetButton.center.y =  self.sheetView.center.y - CGFloat(60)
            self.sheetTitle.frame.origin.y = self.actualScreenBounds.height
            self.sheetImageView.frame.origin.y = self.actualScreenBounds.height + 50
            self.sheetText.frame.origin.y = self.actualScreenBounds.height + 50
            
            self.softOpacityLayer.alpha = 0
        }, completion: { finished in
            self.softOpacityLayer.removeFromSuperview()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



