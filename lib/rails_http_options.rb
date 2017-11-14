require "rails_http_options/version"

module RailsHttpOptions
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def options(&options_block)
      @options_block = options_block if block_given?

      return @options_block
    end
  end

  def options
    return head :ok if controller_for(url: request.url).options.nil?

    return render({
      json: instance_exec(
        request,
        params,
        &_controller_for(url: request.url).options
      )
    })
  end

  protected
    def action
      route_details_for(request.url)[:action]
    end

  private
    def controller_for(url:)
      route_details = route_details_for(url)

      return "#{route_details[:controller].titleize.gsub('/', '::').gsub(' ','')}Controller".constantize
    end

    def route_details_for(url)
      @route_details ||= begin
        methods = [:get, :post, :put, :patch, :delete]
        method = methods[0]
        tries ||= 0
        route_details = nil
        begin
          route_details = Rails.application.routes.recognize_path(url, method: method)
          raise ActionController::RoutingError, '' if route_details[:action] == 'route_not_found'
        rescue ActionController::RoutingError => _
          method = methods[tries]
          retry unless (tries += 1) == 5
        else
          return route_details
        end
      end
    end

end
