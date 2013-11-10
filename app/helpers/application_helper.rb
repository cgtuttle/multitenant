module ApplicationHelper

	def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def set_title(title)
    base_title = "FactorySync"
    if title.nil?
      provide :title, base_title
    else
      provide :title, "#{base_title} | #{title}"
    end
  end
  
  def get_item_id
    logger.debug "cookies  = #{cookies[:item_id]}"
    Item.id_by_existence(cookies[:item_id])
  end
  
  def flatten_hash(hash = params, ancestor_names = [])
    flat_hash = {}
    hash.each do |k, v|
      names = Array.new(ancestor_names)
      names << k
      if v.is_a?(Hash)
        flat_hash.merge!(flatten_hash(v, names))
      else
        key = flat_hash_key(names)
        key += "[]" if v.is_a?(Array)
        flat_hash[key] = v
      end
    end

    flat_hash
  end

  def flat_hash_key(names)
    names = Array.new(names)
    name = names.shift.to_s.dup 
    names.each do |n|
      name << "[#{n}]"
    end
    name
  end

  def hash_as_hidden_fields(hash = params)
    hidden_fields = []
    flatten_hash(hash).each do |name, value|
      value = [value] if !value.is_a?(Array)
      value.each do |v|
        hidden_fields << hidden_field_tag(name, v.to_s, :id => nil)          
      end
    end

    hidden_fields.join("\n")
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
