# -*- coding: utf-8 -*-
describe "Qiita::Client" do
  extend WebStub::SpecHelpers

  describe '.fetch_tagged_items' do
    before do
      # こんなデータが API から返される
      @data = [
        {
          'title'               => 'title1',
          'user'                => {'url_name' => 'name1'},
          'updated_at_in_words' => '1 days ago',
          'body'                => '<p>body1</p>'
        },
        {
          'title'               => 'title2',
          'user'                => {'url_name' => 'name2'},
          'updated_at_in_words' => '2 days ago',
          'body'                => '<p>body2</p>'
        },
      ]
      @tag = 'RubyMotion'
    end

    context 'API へのアクセスに成功するとき' do
      before do
        # ここで API をスタブ化
        stub_request(:get, "https://qiita.com/api/v1/tags/#{@tag}/items").
          to_return(json: @data)
#         to_return(body: "Hello!", content_type: "text/plain")
#         to_fail(code: NSURLErrorNotConnectedToInternet)
      end

      it '取得したJSONをもとにオブジェクトが作られる' do
        Qiita::Client.fetch_tagged_items('RubyMotion') {|items, message|
          # ブロックには API から取得したデータを元に作られた
          # Qiita::Item の配列と、エラーメッセージが渡される。
          # あとで検証するためにインスタンス変数に入れる。
          @items   = items
          @message = message
          resume
        }

        wait_max 1.0 do
          # ここで @items, @message の検証を行う。
          @items.count.should.equal @data.count

          @items.each_with_index {|item, index|
            item.title.should.equal      @data[index]['title']
            item.username.should.equal   @data[index]['user']['url_name']
            item.updated_at.should.equal @data[index]['updated_at_in_words']
            item.body.should.equal       @data[index]['body']
          }

          @message.should.be.nil
        end
      end
    end
  end
end
