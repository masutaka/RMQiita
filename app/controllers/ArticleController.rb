class ArticleController < UIViewController
  def viewDidLoad
    super

    self.title = "Qiita"

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table
  end
end
