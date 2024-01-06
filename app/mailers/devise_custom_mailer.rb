class DeviseCustomMailer < Devise::Mailer
  # if self.included_modules.include?(AbstractController::Callbacks)
  #   raise "You've already included AbstractController::Callbacks, remove this line."
  # else
  #   include AbstractController::Callbacks
  # end

  before_action :add_inline_attachment!

  def confirmation_instructions(record)
    super
  end

  def reset_password_instructions(*args)
    super
  end

  def unlock_instructions(record)
    super
  end

  private

  def add_inline_attachment!
    attachments.inline['app_store_badge.png'] = File.read(File.join(Rails.root,'app','assets','images','app_store_badge.png'))
    attachments.inline['google-play-badge.png'] = File.read(Rails.root.join('app', 'assets', 'images', 'google-play-badge.png'))
  end
end