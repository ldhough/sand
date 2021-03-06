//
//  AddClasses.swift
//  iosSand
//
//  Created by Madison Gipson on 3/30/20.
//  Copyright © 2020 Madison Gipson. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct AddClasses: View {
    @ObservedObject var classesListController:ClassesListController
    let screenSize = UIScreen.main.bounds
    var body: some View {
        VStack {
            Text("Add Classes").frame(width: screenSize.width, height: screenSize.width/6, alignment: .center).font(.system(size: 24, weight: .thin, design: .default)).foregroundColor(Color.yellow)
            NavigationView {
                List {
                    ForEach(self.classesListController.classTypeList, id: \.self) { cl in
                    NavigationLink(destination: AddClassesSub(classList: self.classesListController.classDic[cl]!)) {
                            Text(cl)
                        }
                    }
                }
            }
        }
    }
}

struct AddClassesSub: View {
    var classList:[String]
    
    var body: some View {
        List {
            ForEach(classList, id: \.self) { c in
                Button(action : {
                    let ref:DatabaseReference = AppDelegate.shared().studentList.child(SceneDelegate.GUID)
                    AppDelegate.shared().studentList.child(SceneDelegate.GUID).child("classes").observeSingleEvent(of: .value, with: { snapshot in
                        for s in snapshot.value as! [String] {
                            var refExist:Bool = false
                            var toSetRef:[String] = []
                            for x in ClassesListController.studentList {
                                toSetRef.append(x)
                                if x == c {
                                    refExist = true
                                }
                            }
                            if !refExist {
                                toSetRef.append(c)
                                //ClassesListController.studentList.append(c)
                                ref.child("classes").setValue(toSetRef)
                            }
                            //ClassesListController.studentList.append(s)
                        }
                        })
                }) {
                    Text(c)
                }
            }
        }
    }
    
}
