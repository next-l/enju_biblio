module EnjuBiblio
  module ApplicationHelper
    def form_icon(carrier_type)
      if carrier_type.attachment.attached?
        image_tag(carrier_type.attachment, size: '16x16', class: 'enju_icon', alt: carrier_type.display_name)
      else
        image_tag('icons/help.png', size: '16x16', class: 'enju_icon', alt: t('page.unknown'))
      end
    end

    def content_type_icon(content_type)
      case content_type.name
      when 'text'
        image_tag('icons/page_white_text.png', size: '16x16', class: 'enju_icon', alt: content_type.display_name)
      when 'still_image'
        image_tag('icons/picture.png', size: '16x16', class: 'enju_icon', alt: content_type.display_name)
      when 'sounds'
        image_tag('icons/sound.png', size: '16x16', class: 'enju_icon', alt: content_type.display_name)
      when 'two_dimensional_moving_image'
        image_tag('icons/film.png', size: '16x16', class: 'enju_icon', alt: content_type.display_name)
      else
        image_tag('icons/help.png', size: '16x16', class: 'enju_icon', alt: t('page.unknown'))
      end
    rescue NoMethodError
      image_tag('icons/help.png', size: '16x16', class: 'enju_icon', alt: t('page.unknown'))
    end

    def agent_type_icon(agent_type)
      case agent_type
      when 'person'
        image_tag('icons/user.png', size: '16x16', class: 'enju_icon', alt: 'Person')
      when 'corporate_body'
        image_tag('icons/group.png', size: '16x16', class: 'enju_icon', alt: 'CorporateBody')
      else
        image_tag('icons/help.png', size: '16x16', class: 'enju_icon', alt: t('page.unknown'))
      end
    end

    def agents_list(agents = [], options = {})
      return nil if agents.blank?
      agents_list = []
      if options[:nolink]
        agents_list = agents.map{|agent| agent.full_name}
      else
        agents_list = agents.map{|agent| link_to(agent.full_name, manifestations_path(query: "\"#{agent.full_name}\""), options)}
      end
      agents_list.join(" ").html_safe
    end

    def identifier_link(identifier)
      case identifier.identifier_type.name
      when 'iss_itemno'
        link_to identifier.body, "https://iss.ndl.go.jp/books/#{identifier.body}"
      else
        identifier.body
      end
    end
  end
end
