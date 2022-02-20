//
//  DinoViewController.swift
//  Task1
//
//  Created by Shwait Kumar on 18/02/22.
//

import UIKit

class DinoViewController: UIViewController {

    @IBOutlet weak var tblDino: UITableView!
    
    @IBOutlet weak var cvDino: UICollectionView!
    
    var dinoImagesArray = ["Dino\(1)", "Dino\(2)", "Dino\(3)", "Dino\(4)", "Dino\(5)", "Dino\(6)", "Dino\(7)", "Dino\(8)", "Dino\(9)"]
    
    var dinoNamesArray = ["aachenosaurus",
                          "aardonyx",
                          "abelisaurus",
                          "abrictosaurus",
                          "abrosaurus",
                          "abydosaurus",
                          "acantholipan",
                          "beelemodon",
                          "beibeilong",
                          "beipiaognathus",
                          "beipiaosauruss",
                          "camptosaurus",
                          "campylodon",
                          "dracopelta",
                          "dracorex",
                          "dracoraptor",
                          "dracovenator",
                          "equijubus",
                          "erectopus",
                          "erketu",
                          "ferganocephale",
                          "frenguellisaurus",
                          "foraminacephale",
                          "gastonia",
                          "geminiraptor",
                          "haya",
                          "hecatasaurus",
                          "heilongjiangosaurus",
                          "itemirus",
                          "iuticosaurus",
                          "jainosaurus",
                          "jaklapallisaurus",
                          "kazaklambia",
                          "lythronax",
                          "macelognathus",
                          "machairasaurus",
                          "nemegtia",
                          "nemegtomaia",
                          "nemegtosaurus",
                          "orcomimus",
                          "orkoraptor",
                          "pyroraptor",
                          "qantassaurus",
                          "rajasaurus",
                          "rapator",
                          "rapetosaurus",
                          "raptorex",
                          "syrmosaurus",
                          "szechuanosaurus",
                          "tyrannosaurus",
                          "tyrannotitan",
                          "uberabatitan",
                          "volgatitan",
                          "wyleyia",
                          "xenoceratops",
                          "yutyrannus",
                          "zalmoxes"
    ]
    
    var dinoNamesDictionary = [String : [String]]()
    var dinoSectionTitle = [String]()
    
    var timerForDinoImages = Timer()
    var counter = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: cvDino.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 1.0
        flowLayout.sideItemAlpha = 0.6
        flowLayout.spacingMode = .fixed(spacing: 10)
        flowLayout.minimumInteritemSpacing = 0.0
        cvDino.collectionViewLayout = flowLayout
    
        cvDino.showsHorizontalScrollIndicator = false
        
        cvDino.delegate = self
        cvDino.dataSource = self
        
        tblDino.delegate = self
        tblDino.dataSource = self
        
        createDinoNamesDict()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timerForDinoImages = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
    }
    
    @objc func timerAction() {
        counter -= 1
        if counter == 0 {
            showImagesInRightSideDeirection()
            shake()
            counter = 5
            timerAction()
        }
    }

    //Show items in Collection Based on timer
    func showImagesInRightSideDeirection() {
        
        let visibleItems: NSArray = self.cvDino.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        if nextItem.row < dinoImagesArray.count {
            self.cvDino.scrollToItem(at: nextItem, at: .left, animated: true)
        }
        else {
            dinoImagesArray.shuffle()
            cvDino.reloadData()
        }
        
    }
    
    //shake collectionView
    func shake() {
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.5

        animation.isAdditive = true
        cvDino.layer.add(animation, forKey: "shake")
        
    }
    
    //Helper class to create dictionary with first letter of dinosaurs names from dinoNamesArray
    func createDinoNamesDict() {
        
        for dino in dinoNamesArray {
            let firstLetterIndex = dino.index(dino.startIndex, offsetBy: 1)
            let dinoKey = String(dino[..<firstLetterIndex])
            
            if var dinoNameValues = dinoNamesDictionary[dinoKey] {
                dinoNameValues.append(dino)
                dinoNamesDictionary[dinoKey] = dinoNameValues
            }
            else {
                dinoNamesDictionary[dinoKey] = [dino]
            }
        }
        dinoSectionTitle = [String](dinoNamesDictionary.keys)
        dinoSectionTitle = dinoSectionTitle.sorted(by: { $0 < $1 })
    }

}

extension DinoViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //shuffle dinosaurs images array to show random images everytime table reloads
        dinoImagesArray.shuffle()
        return dinoImagesArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DinoCollectionViewCell", for: indexPath) as! DinoCollectionViewCell
        
        let data = dinoImagesArray[indexPath.item]
        
        cell.ivDino.image = UIImage(named: data)
        
        return cell
        
    }
    
}

extension DinoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dinoSectionTitle.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return dinoSectionTitle[section].capitalized
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dinoKey = dinoSectionTitle[section]
        guard let dinoNameValues = dinoNamesDictionary[dinoKey] else { return 0 }
        
        return dinoNameValues.count
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        var dinoSectionTitleForIndex = [String]()
        
        //get capital letters for index
        for name in dinoSectionTitle {
            dinoSectionTitleForIndex.append(name.capitalized)
        }
        
        return dinoSectionTitleForIndex
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let headerView = view as! UITableViewHeaderFooterView
        
        headerView.textLabel?.textColor = UIColor(named: "AccentColor")
        headerView.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18.0)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DinoTableViewCell", for: indexPath) as! DinoTableViewCell
        
        let dinoKey = dinoSectionTitle[indexPath.section]
        if let dinoNameValues = dinoNamesDictionary[dinoKey] {
            cell.textLabel?.text = dinoNameValues[indexPath.row].capitalized
            cell.textLabel?.textColor = UIColor(named: "AccentColor")
            cell.imageView?.image = UIImage(named: "logo")
            cell.imageView?.sizeToFit()
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        //shake cell
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.y"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.5
        animation.isAdditive = true
        
        cell?.layer.add(animation, forKey: "shake")
        //flip dino image inside tapped cell
        cell?.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        
    }
    
}
