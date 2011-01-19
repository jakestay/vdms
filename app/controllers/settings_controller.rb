class SettingsController < ApplicationController
  # GET /settings/edit
  def edit
    @settings = Settings.instance
  end

  # PUT /settings
  def update
    @settings = Settings.instance

    if @settings.update_attributes(params[:settings])
      redirect_to(edit_settings_url, :notice => 'Settings were successfully updated.')
    else
      render :action => 'edit'
    end
  end
end
