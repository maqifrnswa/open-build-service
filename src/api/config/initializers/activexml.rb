require_dependency 'activexml/activexml'

CONFIG['source_protocol'] ||= 'http'

map = ActiveXML::setup_transport_backend(CONFIG['source_protocol'], CONFIG['source_host'], CONFIG['source_port'])

map.connect :directory, 'rest:///source/:project/:package?:expand&:rev&:meta&:linkrev&:emptylink&:view&:extension&:lastworking&:withlinked&:deleted'
map.connect :jobhistory, 'rest:///build/:project/:repository/:arch/_jobhistory?:package&:limit&:code'

map.connect :collection, 'rest:///search/:what?:match',
   id: 'rest:///search/:what/id?:match',
   package: 'rest:///search/package?:match',
   project: 'rest:///search/project?:match'

map.connect :fileinfo, 'rest:///build/:project/:repository/:arch/:package/:filename?:view'

map.connect :buildresult, 'rest:///build/:project/_result?:view&:package&:code&:lastbuild&:arch&:repository'

map.connect :builddepinfo, 'rest:///build/:project/:repository/:arch/_builddepinfo?:package&:limit&:code'

map.connect :statistic, 'rest:///build/:project/:repository/:arch/:package/_statistics'

if defined?(Rack::MiniProfiler)
  ::Rack::MiniProfiler.profile_method(ActiveXML::Transport, :http_do) do |method,url|
    if url.kind_of? String
      "#{method.to_s.upcase} #{url}"
    else
      "#{method.to_s.upcase} #{url.path}?#{url.query}"
    end
  end
end
