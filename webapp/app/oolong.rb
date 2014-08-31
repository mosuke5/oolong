# myapp.rb
require 'sinatra'
require 'sinatra/reloader'

# 独自ファイル
require '../db/database'
require '../config/myconf'

before do
    # 共通変数
end

after do
    logger.info "success"
end

# トップ画面 湿度グラフを表示する
get '/' do
    #湿度データ取得
    @humidity = Measurement_data2.order("id desc").all
    erb :index
end
