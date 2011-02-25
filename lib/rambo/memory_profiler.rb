class MemoryProfiler
    
  def self.profile
    @@prev ||= Hash.new(0)
    @@curr ||= Hash.new(0)
    @@delta ||= Hash.new(0)

    begin
      GC.start
      @@curr.clear
      
      ObjectSpace.each_object do |o|
        @@curr[o.class] += 1 
        #curr[o.class] += Marshal.dump(o).size rescue 1
      end

      @@delta.clear
      (@@curr.keys + @@delta.keys).uniq.each do |k,v|
        @@delta[k] = @@curr[k]-@@prev[k]
      end

      puts "<----- profiler ----->"
      
      @@delta.sort_by { |k,v| -v.abs }[0..19].sort_by { |k,v| -v}.each do |k,v|
        next if v == 0
        
        print "\t -> #{k.name.blue} #{@@curr[k]} "
        
        if v > 0
          print " +#{v}".red
        else
          print " #{v}".green
        end
        
        puts
      end
      
      puts "<----- profiler ----->"

      @@delta.clear
      @@prev.clear
      @@prev.update @@curr
    rescue Exception => err
      STDERR.puts "** memory_profiler error: #{err}"
    end

  end
  
end
