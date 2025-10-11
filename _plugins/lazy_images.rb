Jekyll::Hooks.register :documents, :post_render do |doc|
    if doc.output_ext == '.html'
      # agrega loading="lazy" y decoding="async" a todas las etiquetas <img>
      doc.output.gsub!(/<img(?![^>]*loading=)/, '<img loading="lazy" decoding="async"')
    end
  end