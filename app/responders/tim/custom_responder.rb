module Tim
  class CustomResponder < ActionController::Responder
    # We want different API Behaviour than in default renderer
    def api_behavior(error)
      raise error unless resourceful?

      status = :ok
      begin
        if get? then
          display resource
	elsif has_errors?
          display resource.errors, :status => :unprocessable_entity
        elsif post?
          controller.render :status => :created, :action => "show"
        elsif put?
          controller.render :status => :ok, :action => "show"
        else
          head :no_content
        end
      rescue ActionView::MissingTemplate => e
        display resource, :status => status
      end
    end
  end
end
