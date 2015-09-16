# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
### Logs - to cron
set :output, "log/cron_log.log"

# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#


every 1.day, :at => '9:16 pm' do
# every 2.minutes do
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



# Rails.env




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



