class RoomController < Ramaze::Controller
  engine :Erubis
  layout :default
  helper :account_helper

  def show(id)
    room = Room.get(id)
    @title = "Room##{id}: #{room.name}"
  end

  def create
    room = current_account.rooms.create
    room.save
    redirect "/room/show/#{room.id}"
  end
end
