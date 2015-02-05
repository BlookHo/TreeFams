#
# ActiveSupport patches
#
module ActiveSupport

  # Format the buffered logger with timestamp/severity info.
  class ActiveSupport::Logger::SimpleFormatter
    # SEVERITY_TO_TAG_MAP     = {'DEBUG'=>'meh', 'INFO'=>'fyi', 'WARN'=>'hmm', 'ERROR'=>'wtf', 'FATAL'=>'omg', 'UNKNOWN'=>'???'}
    SEVERITY_TO_TAG_MAP     = {'DEBUG'=>'sql', 'INFO'=>'inf', 'WARN'=>'hmm', 'ERROR'=>'wtf', 'FATAL'=>'omg', 'UNKNOWN'=>'???'}
    SEVERITY_TO_COLOR_MAP   = {'DEBUG'=>'36', 'INFO'=>'32', 'WARN'=>'34', 'ERROR'=>'31', 'FATAL'=>'31', 'UNKNOWN'=>'33'}
                                    # '0;37'          зел           синий          красн         красн        желт?
                                  #30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
     # background colors: 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
    USE_HUMOROUS_SEVERITIES = true

    def call(severity, time, progname, msg)
      if USE_HUMOROUS_SEVERITIES
        formatted_severity = sprintf("%-3s",SEVERITY_TO_TAG_MAP[severity])
      else
        formatted_severity = sprintf("%-5s",severity)
      end

      # formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
      formatted_time = ""
      color = SEVERITY_TO_COLOR_MAP[severity]

      "\033[0;37m#{formatted_time}\033[0m [\033[#{color}m#{formatted_severity}\033[0m] #{msg.strip} (pid:#{$$})\n"
    end
  end

end
