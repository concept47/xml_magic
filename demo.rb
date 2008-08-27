load 'lib/common_thread/xml/xml_magic.rb'
require 'benchmark'
xml = <<XML
<?xml version="1.0" encoding="utf-8" ?>
<project title="XML Magic" xmlns:media='http://www.w3.org/1999/XSL/Transform'>
  <media:content>This is the content.</media:content>
  <description>Test description.</description>
  <contact type="Project Manager">Anthony</contact>
  <contact type="Worker Bee">Ben</contact>
  <contact type="Designer Bee">Jason</contact>
  <contact type="Admiral Bee">James</contact>
</project>
XML

puts "\n\n** Rexml Implementation"
rexml_bm = Benchmark.measure {
  project_info = CommonThread::XML::XmlMagic.new(xml)

  puts project_info[:title]
  puts project_info.description
   for contact in project_info.contact
     puts "#{contact} the #{contact[:type]}"
   end

}

puts "   user     system      total        real"
puts rexml_bm

begin
  puts "\n\n** LibXML Implementation"
  libxml_bm = Benchmark.measure {
    project_info = CommonThread::LibXML::XmlMagic.new(xml)

    puts project_info[:title]
    puts project_info.description.to_s
     for contact in project_info.contact
       puts "#{contact} the #{contact[:type]}"
     end 

  }

  puts "   user     system      total        real"
  puts libxml_bm
  
rescue Exception => e
  puts "libxml not tested."
end
