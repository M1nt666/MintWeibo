//
//  HScrollViewController.swift
//  MintWeibo
//
//  Created by Mint on 2022/7/22.
//

import SwiftUI

//建立水平滑动View，这个view是UIVC,传入范型Content为SwfitUI对应的view
struct HScrollViewController<Content: View>: UIViewControllerRepresentable {
    
    let pageWidth: CGFloat
    let contentSize: CGSize
    let content: Content
    
    @Binding var leftPercent: CGFloat
    
    init(pageWidth: CGFloat, contentSize: CGSize, @ViewBuilder content: () -> Content, leftPercent: Binding<CGFloat>) {
        self.pageWidth = pageWidth
        self.contentSize = contentSize
        self.content = content()
        //Binding属性前加下划线
        self._leftPercent =  leftPercent
    }
    
    //生成coordinator，因为swiftUI不会自动应用这个类作为视图的coordinator,故需要主动声明
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    //生成UIVC后，会建立的内容
    func makeUIViewController(context: Context) -> some UIViewController {
        //生成滑动视图
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = context.coordinator
        context.coordinator.scrollView = scrollView
        
        //生成vc并把滑动视图作为其内容
        let vc = UIViewController()
        vc.view.addSubview(scrollView)
        
        //把SwiftUI的View添加到UIHostingController中,host起中介的作用，把SwiftUI的View封装成UIKit中的UIVC
        let host = UIHostingController(rootView: content)
        //在vc中添加子UIVC,建立两者的层级关系
        vc.addChild(host)
        //在scrollView中添加host这个内容，而host.view则为SwiftUI的View
        scrollView.addSubview(host.view)
        host.didMove(toParent: vc)
        context.coordinator.host = host
        
        return vc
    }
    //更新UIVC视图
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //将视图从context中取出
        let scrollView = context.coordinator.scrollView!
        scrollView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: contentSize.height)
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint(x: leftPercent * (contentSize.width - pageWidth), y: 0), animated: true)
        //设置host view的位置和大小,位置是0,0，大小与contentSize一样
        context.coordinator.host.view.frame = CGRect(origin: .zero, size: contentSize)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: HScrollViewController
        var scrollView: UIScrollView!
        var host: UIHostingController<Content>!
        //告诉coordinator它的的父类是谁，让它直接透过引用修改这些数据
        init(_ parent: HScrollViewController) {
            self.parent = parent
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            withAnimation {
                //将leftPercent传入进来，判断在页面的左边还是右边，并设置leftPercent的值
                parent.leftPercent = scrollView.contentOffset.x <= parent.pageWidth * 0.5 ? 0 : 1
            }
        }
    }
}

