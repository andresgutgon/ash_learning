defmodule AshLearning.Accounts.User.Changes.RequireConfirmedUser do
  @moduledoc """
  Sets confirmed_at and ensures the user is confirmed after OAuth registration/sign-in.

  Sets `confirmed_at` to the current time for new users, and returns an error if an
  unconfirmed user already exists, preventing OAuth from bypassing email confirmation.
  """
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    changeset
    |> Ash.Changeset.change_attribute(:confirmed_at, DateTime.utc_now())
    |> Ash.Changeset.after_action(fn _changeset, user ->
      case user.confirmed_at do
        nil -> {:error, "Unconfirmed user exists already"}
        _ -> {:ok, user}
      end
    end)
  end
end
