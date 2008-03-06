require File.dirname(__FILE__) + '/test_helper.rb'

class TestXmlMagic < Test::Unit::TestCase

  def setup
  end
  
  def test_xml_magic
    x = CommonThread::XML::XmlMagic.new('<project title="Sewer work"><media:content>This is the content.</media:content><type>New</type><contact name="Anthony">Anthony</contact><contact name="Ben">Ben</contact><contact name="Jason">Jason</contact><description>Test description.</description></project>')
    assert_equal("Sewer work", x[:title])
    assert_equal("New", x.type.to_s)
    assert_equal("Anthony", x.contact[0][:name])
    x.contact.each do |contact|
      assert(contact[:name] != nil, "Attribute name should not be nil")
      assert(contact[:phone] == nil, "Attribute phone should be nil")
    end
    assert_equal(3, x.contact(:count))
    assert_equal("Test description.", x.description.to_s)
    assert_equal("AnthonyBenJason", x.contact.to_s)
    assert_equal(nil, x.note)
    assert_equal(nil, x.content)
    x.namespace = "media"
    assert_equal("This is the content.", x.content.to_s)
    x.namespace = ""
    assert_equal(nil, x.content)    
  end
end
