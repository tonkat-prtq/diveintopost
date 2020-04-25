class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]
  before_action :set_agenda, only: %i[destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  # アジェンダ削除機能を追加 by kato
  def destroy
    team = Team.friendly.find(current_user.keep_team_id)
    asign = Assign.find(current_user.id)

    if current_user == @agenda.user || asign.team.owner == @agenda.user
    @agenda.destroy
    redirect_to dashboard_path
    else
      redirect_to dashboard_path, notice: I18n.t('views.messages.adgenda_destroy')
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
