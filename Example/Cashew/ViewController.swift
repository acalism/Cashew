//
//  ViewController.swift
//  Cashew
//
//  Created by acalism@gmail.com on 12/02/2019.
//  Copyright (c) 2019 acalism@gmail.com. All rights reserved.
//

import UIKit
import Cashew

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func onChangeLanguageButton(_ sender: Any)
    {
        let supportedLanguages = ["en", "zh-Hans"]
        let currentLanguage = Bundle.cashew_language;
        let ac = UIAlertController(title: "Current Language is \(currentLanguage ?? "")", message: "Change To", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        for lang in supportedLanguages {
            ac.addAction(UIAlertAction(title: lang, style: .default, handler: { (action) in
                Bundle.cashew_language = lang
                guard let window = UIApplication.shared.delegate?.window ?? nil else { return }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                window.rootViewController = storyboard.instantiateInitialViewController()
            }))
        }
        present(ac, animated: true, completion: nil)
    }
}

