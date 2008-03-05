module CommonThread
  module XML
    # Class that makes accessing xml objects more like any other ruby object
    # thanks to the magic of method missing
    class XmlMagic
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

      def class(selection=nil)
        evaluate("class", selection)
      end

      def each
        @element.each {|e| yield CommonThread::XML::XmlMagic.new(e, @namespace)}
      end

      def id(selection=nil)
        evaluate("id", selection)
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

      def type(selection=nil)
        evaluate("type", selection)
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
end
