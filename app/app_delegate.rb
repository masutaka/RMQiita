# -*- coding: utf-8 -*-
class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # ドリルダウンの遷移を作りたいので EntriesController のインスタンスを作り、UINavigationController の中に入れる
    entries_controller = EntriesController.new
    navigation_controller = UINavigationController.alloc.initWithRootViewController(entries_controller)
    @window.rootViewController = navigation_controller
    @window.makeKeyAndVisible
    true
  end
end
