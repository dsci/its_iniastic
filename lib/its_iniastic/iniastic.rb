module Iniastic

  module Core
    
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end
    
    module ClassMethods
      
      def property_collection
        @properties ||= []
      end
      
      #:nodoc
      #author: Daniel Schmidt

      # property creates a instance_variable and setter/getters for this
      # it's like faking a AR Column
      #
      #   property :sms_gateway
      # 
      def property(attribute)
        property_collection << attribute
        define_method("#{attribute.to_s}"){ instance_variable_get("@#{attribute.to_s}") }
        define_method("#{attribute.to_s}="){ |val| instance_variable_set("@#{attribute.to_s}",val)}
      end
      
      #:nodoc
      #author: Daniel Schmidt

      # path specifies the location of the corrosponding ini file
      #
      #   path "#{RAILS_ROOT}/public/ini/data.ini"    
      def path(path_to)
        define_method("path"){ return "#{RAILS_ROOT}/#{path_to}" }
      end
      
      #:nodoc
      #author: Daniel Schmidt

      #Comment for method
      #  
      # delimeter ";"
      def comment(comment)
        define_method("comment"){ return comment }
      end
      
      #:nodoc
      #author: Daniel Schmidt

      #Comment for method
      #
      #  parameter "="  
      def parameter(parameter)
        define_method("parameter"){ return parameter }
      end
      
      
      # loads the model from the given ini file in path
      #
      #
      def load
        ini = self.new
        ini.load
      end
      
    end
    
    module InstanceMethods
      
      #:nodoc
      #author: Daniel Schmidt

      # a collection of properties
      #  
      def properties
        self.class.property_collection
      end
      
      #:nodoc
      #author: Daniel Schmidt

      # setup the file name of the ini if it differs from the model_name (camelcase)
      #  
      def file_name
        
      end
      
      #:nodoc
      #author: Daniel Schmidt

      # loads the file and returns self
      #  
      def load
        read_file.each_pair do |key,value|
          send("#{key.to_s}=",value) if self.methods.include?("#{key.to_s}=")
        end
        return self
      end
      
      #:nodoc
      #author: Daniel Schmidt

      #Comment for method
      #  
      def write
        write_file
      end
      
      alias_method :save,:write
      
      
      private 
      
      def read_file
        values = {}
        File.open(path, "r") do |file|
          while line = file.gets
            unless line[0..0].eql?(comment)
              tmp = line.split(parameter)
              tmp_hash = {tmp[0].to_sym => tmp[1].gsub("\n","")}
              values.merge!(tmp_hash)
            end
          end
        end
        return values
      end
      
      #:nodoc
      #author: Daniel Schmidt

      #writes the ini file (complete)
      #returns true if okay,otherwise false  
      def write_file
        myfile = File.open(path, "w") do |file|
          lines = []
          properties.each do |p|
            value = send(p)
            lines << "#{p.to_s}#{parameter}#{value}\n"
            
          end
          file.write(lines)
        end
        return true
      rescue
        return false
      end
      
    end
    
  end
end