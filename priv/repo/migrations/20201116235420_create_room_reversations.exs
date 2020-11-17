defmodule Meetings.Repo.Migrations.CreateRoomReversations do
  use Ecto.Migration

  def change do
    create table(:room_reservations) do
      add(:customer_id, :binary_id, null: false)
      add(:room_id, :binary_id, null: false)
      add(:reservation_starts_at, :timestamp, null: false)
      add(:reservation_ends_at, :timestamp, null: false)
      add(:status, :text, null: false, defautl: "hold")
      timestamps()
    end

    execute(
      ~S"""
      CREATE FUNCTION room_reservations_check_room_availability() RETURNS TRIGGER AS
      $$
      BEGIN
      IF EXISTS(
        SELECT 1
        FROM room_reservations rr
        WHERE rr.room_id = NEW.room_id
        AND tsrange(rr.reservation_starts_at, rr.reservation_ends_at, '[]') &&
            tsrange(NEW.reservation_starts_at, NEW.reservation_ends_at, '[]')
        AND (
          rr.status = 'confirmed'
        OR rr.inserted_at > CURRENT_TIMESTAMP - interval '24 hours'
        )
      )
      THEN
        RAISE unique_violation USING CONSTRAINT = 'room_reservations_room_reserved';
      END IF;
      RETURN NEW;
      END
      $$ language plpgsql;
      """,
      """
      DROP FUNCTION room_reservations_check_room_availability;
      """
    )

    execute(
      ~S"""
      CREATE TRIGGER room_reservations_check_room_availability_check
      BEFORE INSERT ON room_reservations
      FOR EACH ROW
      EXECUTE PROCEDURE room_reservations_check_room_availability();
      """,
      """
      DROP TRIGGER room_reservations_check_room_availability_check ON room_reservations;
      """
    )
  end
end
