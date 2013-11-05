# -*- coding: utf-8 -*-
class EntriesController < UITableViewController
  # ビューが読み込まれた後で実行されるメソッド
  def viewDidLoad
    super
    @tag = 'RubyMotion'
    self.title = @tag
    @entries = []
    Qiita::Client.fetch_tagged_items(@tag) do |items, error_message|
      if error_message.nil?
        @entries = items
        self.tableView.reloadData
      else
        p error_message
      end
    end
  end
  # テーブルの行数を返すメソッド
  def tableView(tableView, numberOfRowsInSection:section)
    @entries.count
  end
  # テーブルのセルを返すメソッド
  ENTRY_CELL_ID = 'Entry'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(ENTRY_CELL_ID)
    if cell.nil?
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:ENTRY_CELL_ID)
    end
    entry = @entries[indexPath.row]
    cell.textLabel.text = entry.title
    cell.detailTextLabel.text = "#{entry.updated_at} by #{entry.username}"
    cell
  end
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    entry = @entries[indexPath.row]
    # UIWebView を貼付けた ビューコントローラを作成
    controller = UIViewController.new
    webview = UIWebView.new
    webview.frame = controller.view.frame # webview の表示サイズを調整
    controller.view.addSubview(webview)
    # 画面遷移
    navigationController.pushViewController(controller, animated:true)
    # HTML を読み込む
    webview.loadHTMLString(entry.body, baseURL:nil)
  end
end
