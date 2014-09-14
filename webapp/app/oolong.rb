# myapp.rb
require 'sinatra'
require 'sinatra/reloader'
require 'logger'

# 独自ファイル
require './db/database'
require './config/myconf'
require './app/models/measurement_data'

before do
    # 共通変数
end

after do
    logger.info "success"
end

configure do
    
    #機器からの定期データのログ
    @@machine_log = Logger.new("./logs/machine.log", 3)
    @@machine_log.level = Logger::INFO

end

# Test
get '/test' do
    "hello"
end

# トップ画面 湿度グラフを表示する
get '/' do

    #machine idはデフォルトで自分用の1にしておく
    @machine_id = 1
    
    #全てのデータ
    @all_data   = Measurement_data.order("id desc").where(:machine_id=>@machine_id)

    #直近の温度・湿度情報取得

    erb :index

end

# 機器からの定期データ受け取り 
get '/hb/:machine_id' do |id|
    
    #温度と湿度データを受け取り
    humidity    = params[:h]
    temperature = params[:t]
    
    #DBへ保存
    insert = Measurement_data.new(:machine_id=>id,
                                  :measured_date=>Time.now,
                                  :humidity=>humidity,
                                  :temperature=>temperature)

    if insert.save
        @@machine_log.info("[success] Machine id is #{id}.")
    else
        @@machine_log.info("[failed] Machine id is #{id}. Humidity:#{humidity}, Temperature:#{temperature}")
    end

end

# 格納情報の取得API
get '/getdata/:machine_id' do |id|
    
    #content_type 'application/csv'

    #湿度・温度データ取得
    @m_data   = Measurement_data.order("id desc").where(:machine_id=>id)
    @m_header = "header"

    erb :csv, :layout => false
end

get '/humidity/:machine_id' do |id|
    
    content_type 'application/csv'
    attachment 'humidity.csv'

    #湿度データ取得
    @m_data   = Measurement_data.select("id,measured_date,humidity as value").order("id desc").where(:machine_id=>id)
    @m_header = "id,date,value\n"

    erb :csv, :layout => false
end

get '/temperature/:machine_id' do |id|
    
    content_type 'application/csv'
    attachment 'temperature.csv'

    #湿度データ取得
    @m_data   = Measurement_data.select("id,measured_date,temperature as value").order("id desc").where(:machine_id=>id)
    @m_header = "id,date,value\n"

    erb :csv, :layout => false
end

