#Para probar en ambiente de desarrollo 
#ENV['RAILS_ENV'] = "development"
#set :environment, 'development'

env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']


set :output, "#{path}/log/cron_log.log"

every 2.minutes do
  runner "Bodega.cambiar"
end
