class ConnectionPool
  def initialize size
    @size = size
    @jobs = Queue.new
    @pool = Array.new(@size) do
      Thread.new do
        catch(:exit) do 
          loop do
            url,block = @jobs.pop
            block.call(url)
          end
        end
      end
    end
  end

  def schedule(url,block)
    @jobs << [url,block]
  end

  def shutdown
    print "\nShutting down..."
    @pool.each do |pool|
      p = Proc.new { throw :exit }
      schedule("",p)
      print "."
    end
    puts "..."
  end

  def no_active_thread?
    thr = @pool.find() {|thr| thr.status != 'sleep' }
    thr.nil? ? true : false
  end
end





