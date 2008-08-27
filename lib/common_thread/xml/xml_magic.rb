
module CommonThread
  module XML

    # Credit to Jim Weirich at http://onestepback.org/index.cgi/Tech/Ruby/BlankSlate.rdoc
    class BlankSlate
      instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    end    
    
    # Class that makes accessing xml objects more like any other ruby object
    # thanks to the magic of method missing
    class XmlMagic < BlankSlate
      require 'rexml/document'
      
      def initialize(xml, namespace="")
        if xml.class == REXML::Element or xml.class == Array
          @element = xml
        else
          @xml = REXML::Document.new(xml)
          @element = @xml.root
        end
        @namespace = namespace
      end
 
      def each
        @element.each {|e| yield CommonThread::XML::XmlMagic.new(e, @namespace)}
      end
 
      def method_missing(method, selection=nil)
        evaluate(method.to_s, selection)
      end
 
      def namespace=(namespace)
        if namespace and namespace.length > 0
          @namespace = namespace + ":"
        else
          @namespace = ""
        end
      end
      
      def to_s
        if @element.class == Array
          @element.collect{|e| e.text}.join
        else
          @element.text
        end
      end
 
      def [](index, count = nil)
        if index.is_a?(Fixnum) or index.is_a?(Bignum) or index.is_a?(Integer) or index.is_a?(Range)
          if @element.is_a?(Array)
            if count
              CommonThread::XML::XmlMagic.new(@element[index, count], @namespace)
            else
              CommonThread::XML::XmlMagic.new(@element[index], @namespace)
            end
          else
            nil
          end
        elsif index.is_a?(Symbol)
          if @element.is_a?(Array)
            if @element.empty?
              nil
            else
              @element[0].attributes[index.to_s]
            end
          else
            @element.attributes[index.to_s]
          end
        end
      end
 
      private
      def evaluate(name, selection)
        
        if @element.is_a?(Array)
          elements = @element[0].get_elements(@namespace + name)
        else
          elements = @element.get_elements(@namespace + name)
        end
        
        if elements.empty?
          nil
        else
          if selection == :count
            elements.length
          else
            CommonThread::XML::XmlMagic.new(elements, @namespace)
          end
        end
      end
    end
  end
  
   module LibXML
     
      class BlankSlate
        instance_methods.each { |m| undef_method m unless m =~ /^__/ }
      end    
     
     class XmlMagic < BlankSlate
       require 'libxml'

       def initialize(xml, namespace="")
        if xml.is_a?(::LibXML::XML::Node) or xml.class == Array
          @element = xml
        else
          # At this time, LibXML doesn't support a simple method to convert a string to an XML document
          parser = ::LibXML::XML::Parser.new
          parser.string = xml          
          @xml = parser.parse # returns XML::Document
          @element = @xml.root # returns XML::Node
        end
        @namespace = namespace
       end
       
      def each
        @element.each {|e| yield CommonThread::LibXML::XmlMagic.new(e, @namespace)}
      end

      # I have no idea why the next two methods have to be defined. XmlMagic will choke and try to evaluate `respond_to?`
      # if we don't define them.
      def to_ary
        @element.to_a
      end
      
      def respond_to?(args)
        nil
      end
      
      def method_missing(method, selection=nil)
        evaluate(method.to_s, selection)
      end

      def namespace=(namespace)
        if namespace and namespace.length > 0
          @namespace = namespace + ":"
        else
          @namespace = ""
        end
      end
      
      def to_s
        if @element.class == Array
          @element.collect{|e| e.content}.join
        else
          @element.content
        end
      end

      def [](index, count = nil)
        if index.is_a?(Fixnum) or index.is_a?(Bignum) or index.is_a?(Integer) or index.is_a?(Range) 
          if @element.is_a?(Array)
            if count
              CommonThread::LibXML::XmlMagic.new(@element[index, count], @namespace)
            else
              CommonThread::LibXML::XmlMagic.new(@element[index], @namespace)
            end
          else
            nil
          end
        elsif index.is_a?(Symbol)
          if @element.is_a?(Array)
            if @element.empty?
              nil
            else
              @element[0].attributes[index.to_s]
            end
          else
            @element.attributes[index.to_s]
          end
        end
      end

      private
      def evaluate(name, selection)
        if @element.is_a?(Array)
          elements = @element[0].find(@namespace + name).to_a
        else
          elements = @element.find(@namespace + name).to_a
        end

        if elements.empty?
          nil
        else
          if selection == :count
            elements.length
          else
            CommonThread::LibXML::XmlMagic.new(elements, @namespace)
          end
        end        
      end
     end
   end
end

