# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron


### Logs - to cron
set :output, "log/cron_log.log"


every 1.day, :at => '5:00 pm' do   # 17 () + 7 = 00 MSK - появился стат, at 22 - in PG & in Excel
# every 1.day, :at => '7:00 pm' do   # 19 () + 7 = 02 MSK, at 00 - in PG & in Excel
# every 1.day, :at => '4:00 am' do   # 4 () + 7 = 11 MSK, at 9 - in PG & in Excel, at 8 - in Rails (?)
# every 1.hour do
  runner "WeafamStat.create_stats_row"  #  , environment: :development
  # runner "Counter.increment_invites"    # , environment: :development
  # runner "Counter.increment_disconnects"# , environment: :development
end



# namespace :whenever do
#   task :start, :roles => :app do
#     run "cd #{release_path} && bundle exec whenever --update-crontab"
#   end
# end

# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#

# Learn more: http://github.com/javan/whenever

# every 1.day, :at => '4:30 am' do
#   runner "MyModel.task_to_run_at_four_thirty_in_the_morning"
# end
#
# every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
#   runner "SomeModel.ladeeda"
# end
#
# every :sunday, :at => '12pm' do # Use any day of the week or :weekend, :weekday
#   runner "Task.do_something_great"
# end
#
# every '0 0 27-31 * *' do
#   command "echo 'you can use raw cron syntax too'"
# end
#
# # run this task only on servers with the :app role in Capistrano
# # see Capistrano roles section below
# every :day, :at => '12:20am', :roles => [:app] do
#   rake "app_server:task"
# end

# Whenever ships with three pre-defined job types: command, runner, and rake.
#     You can define your own with job_type.
#
#     For example:
#
#     job_type :awesome, '/usr/local/bin/awesome :task :fun_level'
#
#     every 2.hours do
#       awesome "party", :fun_level => "extreme"
#     end
#
# Would run /usr/local/bin/awesome party extreme every two hours.
# :task is always replaced with the first argument,
# and any additional :whatevers are replaced with the options passed in or by variables that have been defined with set.



