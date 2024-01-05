module ApplicationHelper
  require 'rest-client'
  def inline_icon(filename, options = {})
    @icon_svg_cache ||= {}
    options[:color] ||= "black"
    @icon_svg_cache[options[:color]] ||= {}

    if !@icon_svg_cache[options[:color]].key?(filename)
      file = RestClient.get("https://icons.hackclub.com/api/icons/#{options[:color]}/#{filename}")
      @icon_svg_cache[options[:color]][filename] = Nokogiri::HTML::DocumentFragment.parse file
    end
    doc = @icon_svg_cache[options[:color]][filename].dup
    svg = doc.at_css "svg"
    options[:size] ||= 32
    options[:style] ||= ""
    if options[:size]
      options[:width] ||= options[:size]
      options[:height] ||= options[:size]
      options.delete :size
    end
    options.each { |key, value| svg[key.to_s] = value }
    doc.to_html.html_safe
  end
end
