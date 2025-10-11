Jekyll::Hooks.register :documents, :post_write do |doc|
  if doc.output_ext == '.html'
    content = File.read(doc.destination(doc.site.dest))
    content.gsub!(/<img(?![^>]*loading=)/, '<img loading="lazy" decoding="async"')
    File.write(doc.destination(doc.site.dest), content)
  end
end
