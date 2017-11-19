class Factory
  def self.new(*args, &block)
      class_name = if args.first.is_a? String
                   unless args.first.match(/^[A-Z]/)
                     raise(NameError, "identifier #{args.first} needs to be constant")
                   end
                   args.shift
                   end
      new_class = Factory.const_set(class_name, Class.new{
      attr_accessor *args
      
      define_method :initialize do |*vars|
        raise ArgumentError if vars.size > args.size

        args.each_with_index do |var, index|
          instance_variable_set "@#{var}", vars[index]
      end
      end
      })

      def ==(obj)
        self.class == obj.class && values == obj.values
      end

      def [](arg)
        arg.is_a?(Integer) ? to_a[arg] : send(arg.to_sym)
      end

      def []=(arg, value)
        instance_variable_set("@#{arg}", value)
      end
      
      def dig(*args)
          hash.dig(*args)
      end
  

      def each(&block)
        values.each(&block)
      end    
      
      def each_pair(&name_block)
        to_h.each_pair(&name_block)
      end

      def length
        self.values.length
      end
      
      def members
        instance_variables.map { |a| ("#{a}"[1..-1]).to_sym }
      end
      
      def select(&block)
        values.select(&block)
      end
      
      def dig(*keys)
        to_h.dig(*keys)
      end
      
      def each_pair(&block)
        to_h.each_pair(&block)
      end

      def values
        instance_variables.map { |arg| instance_variable_get("#{arg}") }
      end

      def values_at(*select)
        values.values_at(*select)
      end
    
      def hash
        Hash[instance_variables.map { |name| [name.to_s.delete('@').to_sym, instance_variable_get(name)]}]
      end
      
      


      alias_method :to_a, :values 
      alias_method :to_s, :inspect
      alias_method :size, :length
      alias_method :to_h, :hash
      
      
      class_eval(&block) if block_given?
end
    
end
