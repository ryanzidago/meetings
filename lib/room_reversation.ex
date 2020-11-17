defmodule Meetings.RoomReservations do
  use Ecto.Schema

  import Ecto.Changeset

  schema "room_reservations" do
    field(:customer_id, :binary_id)
    field(:room_id, :binary_id)
    field(:reservation_starts_at, :utc_datetime)
    field(:reservation_ends_at, :utc_datetime)
    field(:status, :string)
    timestamps()
  end

  def create(%{} = reservation_data) do
    %__MODULE__{}
    |> cast(reservation_data, [
      :customer_id,
      :room_id,
      :reservation_starts_at,
      :reservation_ends_at
    ])
    |> validate_required([:customer_id, :room_id, :reservation_starts_at, :reservation_ends_at])
    |> put_change(:status, "hold")
    |> unique_constraint(:room_id,
      message: "has already been taken",
      name: "room_reservations_room_reserved"
    )
    |> Meetings.Repo.insert()
  end

  def build_room do
    %{
      customer_id: "cdeb634b-8c20-4188-8f8c-ae7e2f056588",
      room_id: "9a79d932-cdd7-4160-888d-cfcf0b4c4b8b",
      reservation_starts_at: DateTime.utc_now(),
      reservation_ends_at: DateTime.utc_now() |> DateTime.add(999_999, :second),
      status: "confirmed"
    }
  end
end
