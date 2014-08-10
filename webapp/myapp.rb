# myapp.rb
require 'sinatra'
require 'sinatra/reloader'

# 独自ファイル
require './helpers/tool'
require './models/foo'
require './config/database'

before do
    # 共通変数
    @author = "mosuke"
end

after do
    logger.info "success"
end

# トップ画面 湿度と温度のグラフを表示する
get '/' do
    @comments = Hoge.order("id desc").all

    erb :index
end


get '/hoge/:name' do |n|
    
    @name = strong(n)
    erb :hoge
end


get '/modeltest' do
    Foo.footest()
end

get '/graph' do
    erb :graph
end
