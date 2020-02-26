class ObservationsController < ApplicationController
  before_action :find_user
  before_action :find_observation, only: [:destroy]

    def index
      @observations = Observation.where(give_observations: params[:user_id]).all
    end

    def create
      if already_observed?
        flash[:alert] = t(:cannot_observe_2)
      else
        if current_user.give_observations.create(being_observed_id: @user.id)
          flash[:notice] = t(:observed)
          redirect_to @user
        else
          flash[:notice] = t(:observing_failed)
          redirect_to @user
        end
      end

    end

    def destroy
      if !(already_observed?)
        flash[:alert] = t(:cannot_unobserve)
      else
        if @observation.destroy
          flash[:notice] = t(:unobserved)
          redirect_to @user
        else
          flash[:notice] = t(:unobserving_failed)
          redirect_to @user
        end
      end
    end

    private

    def find_user
      @user = User.find(params[:user_id])
    end

    def already_observed?
      Observation.where(observed_by_id: current_user.id, being_observed_id: params[:user_id]).exists?
    end

    def find_observation
      @observation = current_user.give_observations.find(params[:id])
    end

end
