module ApplicationHelper
    def heading_class(value)
        if params[:order] == value
            return 'hilite'
        else
            return ''
        end
    end
end
