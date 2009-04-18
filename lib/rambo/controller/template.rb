module Template
  
  @@template_cache = {}
  
  def erb(template, options={}, locals={})
    require 'erb' unless defined? ::ERB
    render :erb, template, options, locals
  end
  
  private
    def render(engine, template, options={}, locals={})
      # extract generic options
      layout = options.delete(:layout)
      layout = :layout if layout.nil? || layout == true
      views = options.delete(:views) || "./view"
      locals = options.delete(:locals) || locals || {}
 
      # render template
      data = lookup_template(engine, template, views)
      output = __send__("render_#{engine}", template, data, options, locals)
 
      # render layout
      if layout && data = lookup_layout(engine, layout, views)
        __send__("render_#{engine}", layout, data, options, {}) { output }
      else
        output
      end
    end
 
    def lookup_template(engine, template, views_dir)
      case template
      when Symbol
        # if cached = @@template_cache[template]
        #   cached
        # else
          path = ::File.join(views_dir, "#{template}.#{engine}")
          res = ::File.read(path)
        #  @@template_cache[template] = res
        #  res
        #end
      when Proc
        template.call
      when String
        template
      else
        raise ArgumentError
      end
    end
 
    def lookup_layout(engine, template, views_dir)
      lookup_template(engine, template, views_dir)
    rescue Errno::ENOENT
      nil
    end
 
    def render_erb(template, data, options, locals, &block)
      original_out_buf = @_out_buf
      data = data.call if data.kind_of? Proc
 
      instance = ::ERB.new(data, nil, nil, '@_out_buf')
      locals_assigns = locals.to_a.collect { |k,v| "#{k} = locals[:#{k}]" }
 
      src = "#{locals_assigns.join("\n")}\n#{instance.src}"
      eval src, binding, '(__ERB__)', locals_assigns.length + 1
      @_out_buf, result = original_out_buf, @_out_buf
      result
    end
end