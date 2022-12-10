# frozen_string_literal: true

class Events::AttendancesController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    if @event.only_woman?
      if current_user.woman?
        event_attendance = current_user.attend(@event)
        (@event.attendees - [current_user] + [@event.user]).uniq.each do |user|
          NotificationFacade.attended_to_event(event_attendance, user)
        end
        redirect_back(fallback_location: root_path, success: '参加の申込をしました')
      else
        render template: 'events/show'
      end
    else
      event_attendance = current_user.attend(@event)
      (@event.attendees - [current_user] + [@event.user]).uniq.each do |user|
        NotificationFacade.attended_to_event(event_attendance, user)
      end
      redirect_back(fallback_location: root_path, success: '参加の申込をしました')
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    current_user.cancel_attend(@event)
    redirect_back(fallback_location: root_path, success: '申込をキャンセルしました')
  end
end
