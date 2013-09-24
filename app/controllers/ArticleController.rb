# -*- coding: utf-8 -*-
class ArticleController < UIViewController
  def viewDidLoad
    super

    self.title = "Qiita"

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table

    @table.dataSource = self
    @table.delegate = self
    @data = ("A".."Z").to_a

    # http://d.hatena.ne.jp/naoya/20120831/1346409758

    url = 'https://qiita.com/api/v1/tags/RubyMotion/items'
    BW::HTTP.get(url) do |response|
      if response.ok?
        json = BW::JSON.parse(response.body.to_s)
        json.each do |data|
          p "======================================="
          p "タイトル: #{data["title"]}"
          p "更新日: #{data["updated_at_in_words"]}"
          p "ユーザ: #{data["user"]["url_name"]}"
          p "======================================="
        end
      else
        App.alert(response.error_message)
      end
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    cell.textLabel.text = @data[indexPath.row]
    p cell

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.count
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    alert = UIAlertView.alloc.init
    alert.message = "#{@data[indexPath.row]} tapped!"
    alert.addButtonWithTitle "OK"
    alert.show
  end
end
