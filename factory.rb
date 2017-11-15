class Factory
  def self.new(*args, &block)
  
    Class.new do
      attr_accessor(*args)
      
      def initialize(*vars)
        args.each_index { |index| instance_variable_set(:"@#{args[index]}", vars[index]) }
      end

      define_method :args do
        args
      end
      
      def ==(obj)
        self.class == obj.class && values == obj.values
      end

      def [](arg)
        #if arg.is_a?(Integer)
        instance_variable_get("@#{arg}")
        end
      end

      def []=(arg, value)
        instance_variable_set("@#{arg}", value)
      end
  

      def each(&block)
        values.each(&block)
      end    

      def length
        args.size
      end

      def select(&block)
        values.select(&block)
      end

      def values
        instance_variables.map { |arg| instance_variable_get("#{arg}") }
      end

      def values_at(*selector)
        values.values_at(*selector)
      end

      alias_method :to_a, :values 
      alias_method :to_s, :inspect
      alias_method :size, :length

    end
  end
  end
