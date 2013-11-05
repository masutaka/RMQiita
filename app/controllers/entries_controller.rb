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
    self.tableView.registerClass(EntryCell, forCellReuseIdentifier:'Entry')
  end

  # テーブルの行数を返すメソッド
  def tableView(tableView, numberOfRowsInSection:section)
    @entries.count
  end

  # テーブルのセルを返すメソッド
  ENTRY_CELL_ID = 'Entry'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(ENTRY_CELL_ID, forIndexPath:indexPath)

    entry = @entries[indexPath.row]
    cell.entry = entry
    cell.setNeedsDisplay # 再描画させる

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    entry = @entries[indexPath.row]
    controller = EntryController.new
    controller.entry = entry
    # 画面遷移
    navigationController.pushViewController(controller, animated:true)
  end
end
