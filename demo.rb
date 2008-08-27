load 'lib/common_thread/xml/xml_magic.rb'

xml = <<XML
<?xml version="1.0" encoding="utf-8" ?>
<project title="XML Magic" xmlns:media='http://www.w3.org/1999/XSL/Transform'>
  <media:content>This is the content.</media:content>
  <description>Test description.</description>
  <other_thing>blah</other_thing>
  <contact type="Project Manager">Anthony</contact>
  <contact type="Worker Bee">Ben</contact>
  <contact type="Designer Bee">Jason</contact>
</project>
XML

puts "\n\n!! Testing Rexml"
project_info = CommonThread::XML::XmlMagic.new(xml)

puts project_info[:title]
puts project_info.description
 for contact in project_info.contact
   puts "#{contact} the #{contact[:type]}"
 end
 
puts "\n\n!! Testing LibXML"
project_info = CommonThread::LibXML::XmlMagic.new(xml)

puts project_info[:title]
# slightly different approach to get the text. Without to_s you get the XML tags printed as well as the text
# only happens for a non-repeating node (unlike `contact`)
puts project_info.description.to_s
 for contact in project_info.contact
   puts "#{contact} the #{contact[:type]}"
 end 