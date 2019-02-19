require "google/cloud/vision"
# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @vision = Google::Cloud::Vision.new(
    project: "vote-201701",
    keyfile: "./google/key.json"
    )
    
    @img_analyst = ConfirmImg.new
    @img_analyst.image_analyst = params[:image_analyst]
    
    if @img_analyst.save
      @local_to_google_transfer = @vision.image "#{@img_analyst.image_analyst}" #AWS 저장소 전용
      
      @local_to_google_transfer.document.words.each do |x|
        if x.to_s.size == 9
          @std_number = x.to_s
          if x.to_s == "201210790"
            @std_email = "shsvkdldj@naver.com"
            @std_major = "컴퓨터학부"
          end
          
          if x.to_s == "201514879"
            @std_email = "kbs4674@kangwon.ac.kr"
            @std_major = "컴퓨터학부"
          end
          
          if x.to_s == "201313533"
            @std_email = "twysg@likelion.org"
            @std_major = "인문학부"
          end
        end
      end
    end
    super
  end

  # POST /resource
  #def create
  #  super
  #end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
