#Para probar en ambiente de desarrollo 
#ENV['RAILS_ENV'] = "development"
#set :environment, 'development'

env :GEM_PATH, '/home/deploy/tigrupo7/shared/bundle/ruby/2.3.0'


set :output, "#{path}/log/cron_log.log"

every 2.minutes do
  runner "Bodega.cambiar"
end
