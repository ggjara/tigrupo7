#Para probar en ambiente de desarrollo 
#ENV['RAILS_ENV'] = "development"
#set :environment, 'development'

set :output, "#{path}/log/cron_log.log"

job_type :runner, "cd #{path} && RAILS_ENV=production /home/deploy/.rvm/wrappers/ruby 2.3.0@default/bundle exec rails runner ':task' :output"


every 2.minutes do
  runner "Bodega.cambiar"
end
