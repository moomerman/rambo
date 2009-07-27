module Template
  
  @@template_cache = {}
  
  def erb(template, options={}, locals={})
    require 'erb' unless defined? ::ERB
    render :erb, template, options, locals
  end
  
  def haml(template, options={}, locals={})
    require 'haml' unless defined? ::Haml
    render :haml, template, options, locals
  end
  
  private
    def render(engine, template, options={}, locals={})
      # extract generic options
      layout = options.delete(:layout)
      layout = :layout if layout.nil? || layout == true
      views = options.delete(:views) || "./view"
      locals = options.delete(:locals) || locals || {}

      # render template
      data, options[:filename], options[:line] = lookup_template(engine, template, views)
      output = __send__("render_#{engine}", data, options, locals)

      # render layout
      if layout
        data, options[:filename], options[:line] = lookup_layout(engine, layout, views)
        if data
          output = __send__("render_#{engine}", data, options, locals) { output }
        end
      end

      output
    end
 
    def lookup_template(engine, template, views_dir)
      case template
      when Symbol
        # if cached = @@template_cache[template]
        #   cached
        # else
          path = ::File.join(views_dir, "#{template}.#{engine}")
          [ ::File.read(path), path, 1 ]
        #  @@template_cache[template] = res
        #  res
        #end
      when Proc
        [template.call, template, 1]
      when String
        [template, template, 1]
      else
        raise ArgumentError
      end
    end
 
    def lookup_layout(engine, template, views_dir)
      lookup_template(engine, template, views_dir)
    rescue Errno::ENOENT
      nil
    end
 
    def render_erb(data, options, locals, &block)
      original_out_buf = @_out_buf
      data = data.call if data.kind_of? Proc
 
      instance = ::ERB.new(data, nil, nil, '@_out_buf')
      locals_assigns = locals.to_a.collect { |k,v| "#{k} = locals[:#{k}]" }
 
      src = "#{locals_assigns.join("\n")}\n#{instance.src}"
      eval src, binding, '(__ERB__)', locals_assigns.length + 1
      @_out_buf, result = original_out_buf, @_out_buf
      result
    end
    
    def render_haml(data, options, locals, &block)
      ::Haml::Engine.new(data, options).render(self, locals, &block)
    end
end