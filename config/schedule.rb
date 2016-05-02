#Para probar en ambiente de desarrollo 
#ENV['RAILS_ENV'] = "development"
#set :environment, 'development'

env :PATH, ENV['PATH']
env :GEM_PATH, '/home/deploy/.rvm/gems/ruby-2.3.0@global'


set :output, "#{path}/log/cron_log.log"

every 2.minutes do
  runner "Bodega.cambiar"
end
