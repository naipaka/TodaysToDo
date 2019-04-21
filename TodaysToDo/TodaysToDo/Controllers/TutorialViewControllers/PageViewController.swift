//
//  PageViewController.swift
//  UIScrolllView_carousel
//
//  Created by rMac on 2019/04/20.
//  Copyright © 2019 naipaka. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }
    
    func getFirst() -> TutorialFirstViewController {
        return storyboard!.instantiateViewController(withIdentifier: "TutorialFirstViewController") as! TutorialFirstViewController
    }
    
    func getSecond() -> TutorialSecondViewController {
        return storyboard!.instantiateViewController(withIdentifier: "TutorialSecondViewController") as! TutorialSecondViewController
    }
    
    func getThird() -> TutorialThirdViewController {
        return storyboard!.instantiateViewController(withIdentifier: "TutorialThirdViewController") as! TutorialThirdViewController
    }
    
    func getFourth() -> TutorialFourthViewController {
        return storyboard!.instantiateViewController(withIdentifier: "TutorialFourthViewController") as! TutorialFourthViewController
    }
    
    func getFifth() -> TutorialFifthViewController {
        return storyboard!.instantiateViewController(withIdentifier: "TutorialFifthViewController") as! TutorialFifthViewController
    }
    
    func getSixth() -> TutorialSixthViewController {
        return storyboard!.instantiateViewController(withIdentifier: "TutorialSixthViewController") as! TutorialSixthViewController
    }
    
    func getSeventh() -> TutorialSeventhViewController {
        return storyboard!.instantiateViewController(withIdentifier: "TutorialSeventhViewController") as! TutorialSeventhViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: TutorialSeventhViewController.self) {
            return getSixth()
        } else if viewController.isKind(of: TutorialSixthViewController.self) {
            return getFifth()
        } else if viewController.isKind(of: TutorialFifthViewController.self) {
            return getFourth()
        } else if viewController.isKind(of: TutorialFourthViewController.self) {
            return getThird()
        } else if viewController.isKind(of: TutorialThirdViewController.self) {
            return getSecond()
        } else if viewController.isKind(of: TutorialSecondViewController.self) {
            return getFirst()
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: TutorialFirstViewController.self) {
            return getSecond()
        } else if viewController.isKind(of: TutorialSecondViewController.self) {
            return getThird()
        } else if viewController.isKind(of: TutorialThirdViewController.self) {
            return getFourth()
        } else if viewController.isKind(of: TutorialFourthViewController.self) {
            return getFifth()
        } else if viewController.isKind(of: TutorialFifthViewController.self) {
            return getSixth()
        } else if viewController.isKind(of: TutorialSixthViewController.self) {
            return getSeventh()
        } else {
            return nil
        }
    }
}

