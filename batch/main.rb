require 'csv'
require 'net/sftp'
require 'pp'
require 'yaml'
require 'mysql2'
require 'active_record'

class Kpitrend

    @@kpi_all  = Hash.new { |hash,key| hash[key] = Hash.new {0} }
    @@kpi_push = Hash.new { |hash,key| hash[key] = Hash.new {0} } 
    @@kpi_pull = Hash.new { |hash,key| hash[key] = Hash.new {0} }
    
    @@config = YAML.load_file("./config.yml")
    
    def initialize

        #DB接続
        ActiveRecord::Base.establish_connection(@@config["db"]["development"])

    end
    
    ##メイン処理
    #通常時は本メソッドを実行
    def main(filename)
        
        self.get_csvfile(filename)

        self.operate_csv(filename)
        
        @@kpi_all.each do |n|
            pp n
        end

    end
    
    ##データファイル取得
    #リモートサーバよりSFTPでファイルを取得
    #接続先などはconfig.yml記載
    def get_csvfile(filename)
        
        sftp_hostname = @@config["sftp"]["host"]
        sftp_username = @@config["sftp"]["user"]
        remote_file   = @@config["sftp"]["remote_path"]+filename
        local_file    = @@config["sftp"]["local_path"]+filename

        #sftp connect
        Net::SFTP.start(sftp_hostname,sftp_username) do |sftp|
            
            #download file
            sftp.download!(remote_file, local_file)

        end

    end

    #csv操作
    def operate_csv(filename)

        CSV.foreach("./data/#{filename}") do |kpi|

            #対象外データ(Y.IE...)なら終了
            if /^Y.IE/ =~ kpi[0]
                next
            end
            
            #データの時間取得
            kpitime = kpi[1][11,2]

            #Y.S1.. or Y.S2.. 
            if /^Y.(S1|S2)/ =~ kpi[0]
                @@kpi_push[:"#{kpitime}"][:value_a] += kpi[2].to_i
                @@kpi_push[:"#{kpitime}"][:value_b] += kpi[3].to_i
                @@kpi_push[:"#{kpitime}"][:value_c] += kpi[4].to_i
                @@kpi_push[:"#{kpitime}"][:ap_count] += 1

            #Y.S3
            elsif /^Y.S3/ =~ kpi[0]
                @@kpi_pull[:"#{kpitime}"][:value_a] += kpi[2].to_i
                @@kpi_pull[:"#{kpitime}"][:value_b] += kpi[3].to_i
                @@kpi_pull[:"#{kpitime}"][:value_c] += kpi[4].to_i
                @@kpi_pull[:"#{kpitime}"][:ap_count] += 1

            end
            
            #all
            @@kpi_all[:"#{kpitime}"][:value_a] += kpi[2].to_i
            @@kpi_all[:"#{kpitime}"][:value_b] += kpi[3].to_i
            @@kpi_all[:"#{kpitime}"][:value_c] += kpi[4].to_i
            @@kpi_all[:"#{kpitime}"][:ap_count] += 1

        end
        
    end
    
    #insert db
    def insert_kpidata(date,time,value_a,value_b,value_c,ap_count)

    end

end

class DBKpitrend < Activerecord::Base
    self.table_name = 'measurement_data2'
end
