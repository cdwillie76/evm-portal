set :application, "evm_portal"
set :repository,  "http://svn.theorangeandblue.com/projects/evm_portal/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/cdw_srw/evm.theorangeandblue.com/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "theorangeandblue.com"
role :web, "theorangeandblue.com"
role :db,  "theorangeandblue.com", :primary => true

set :user, "cdw_srw"
set :svn_username, "chris"
set :svn_password, "chris_movint"

desc "Restart the web server." 
task :restart_web_server, :roles => :web do
  run "killall -q dispatch.fcgi" 
  run "chmod 755 #{current_path}/public/dispatch.fcgi" 
  run "touch #{current_path}/public/dispatch.fcgi" 
end

after "deploy:start", :restart_web_server