def xml_request(root, attributes = {})
  xml_root = root.to_s.camelize
  ns_root = "<#{xml_root} xmlns:ns2=\"http://www.intuit.com/sb/cdm/qbo\" xmlns=\"http://www.intuit.com/sb/cdm/v2\" xmlns:ns3=\"http://www.intuit.com/sb/cdm\">"
  xml = xml_fragment(root, attributes)
  /#{
      xml.gsub("<#{xml_root}>", ns_root)
  }/
end

def xml_response(root, attributes = {})
  xml_root = root.to_s.camelize
  defaults = {
    id: 42,
    sync_token: 0,
    meta_data: {
      create_time: '2010-09-13T04:11:06-07:00',
      last_update_time: '2010-09-13T04:11:06-07:00'
    }
  }
  ns_root = "<#{xml_root} xmlns=\"http://www.intuit.com/sb/cdm/v2\" xmlns:ns2=\"http://www.intuit.com/sb/cdm/qbopayroll/v1\" xmlns:ns3=\"http://www.intuit.com/sb/cdm/qbo\">"
  xml = xml_fragment(root, defaults.merge(attributes))
  xml.gsub("<#{xml_root}>", ns_root)
end

def xml_fragment(root, attributes)
  xml = attributes.to_xml(skip_instruct: true, root: root, skip_types: true, camelize: true)
  xml.to_s.gsub(/>\n\s+</, ">\n<").strip
end