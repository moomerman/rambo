class MooTime < Time
  RFC2822_DAY_NAME  	=  	[ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ]
  RFC2822_MONTH_NAME 	= 	[ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ]
  def httpdate
      t = dup.utc
      sprintf('%s, %02d %s %d %02d:%02d:%02d GMT',
        RFC2822_DAY_NAME[t.wday],
        t.day, RFC2822_MONTH_NAME[t.mon-1], t.year,
        t.hour, t.min, t.sec)
    end
end