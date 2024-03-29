class ApplicationController < ActionController::Base
  User = Struct.new(:id, :first_name, :last_name, :full_name, :username, :email, keyword_init: true)

  around_action :use_request_metadata

  private

  def current_user
    @current_user ||= User.new(
      id: 'fb635307-e831-457b-99f1-097a77056331',
      first_name: 'Dawid',
      last_name: 'Leszczyński',
      full_name: 'Dawid Leszczyński',
      username: 'davebream',
      email: 'dawid@pexels.com'
    )
  end

  def cqrs
    Rails.configuration.cqrs
  end

  def use_request_metadata(&block)
    cqrs.event_store.with_metadata(request_metadata, &block)
  end

  def with_transaction(&block)
    ActiveRecord::Base.transaction(&block)
  end

  def request_metadata
    { user_id: current_user.id, user_email: current_user.email }
  end
end
