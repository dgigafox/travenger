defmodule Travenger.Factory do
  @moduledoc """
  Factory lib for creating records and building schemas
  """
  use ExMachina.Ecto, repo: Travenger.Repo

  alias Travenger.Accounts.{
    Following,
    Invitation,
    User
  }

  alias Travenger.Groups.{
    Group,
    Membership,
    MembershipStatus
  }

  alias Travenger.Groups.Rating, as: GroupRating

  alias Travenger.Notifications.{
    Notification,
    NotificationChange,
    NotificationObject
  }

  def user_factory do
    email = sequence(:email, &"email-#{&1}@example.com")

    %User{
      email: email,
      name: "Darren Gegantino",
      image_url: "http://graph.facebook.com/10216277902323229/picture?type=square",
      first_name: "Darren",
      last_name: "Gegantino",
      gender: "male",
      token:
        "EAAbTLLNZAHhUBAO2GaawhTqbrKAmhfNGdxtEAGVZCYFZAHSCZCfiTnLp1Tvq7VqkRUqQK9zCoXZAUnN9dNe9ZAIPhk3kO4W4H31ZAJVEEiqwLZABmQyQCwwCdKEPU64E2PDaPO3qL0tRy3ZAMPDOzRXL2rq8580dnbFwnZA67oioRHdwZDZD",
      provider: "facebook"
    }
  end

  def group_factory do
    %Group{
      name: sequence("TravelGroup"),
      image_url: "http://website.com/image.png",
      description: "This is a sample group",
      user: build(:user)
    }
  end

  def membership_factory do
    %Membership{
      user: build(:user),
      group: build(:group),
      role: :waiting,
      membership_status: build(:membership_status)
    }
  end

  def membership_status_factory do
    %MembershipStatus{
      status: :pending,
      joined_at: DateTime.utc_now()
    }
  end

  def invitation_factory do
    %Invitation{
      user: build(:user),
      group: build(:group),
      type: :group,
      status: :pending
    }
  end

  def following_factory do
    %Following{
      user: build(:user),
      followed_user: build(:user),
      type: :user
    }
  end

  def notification_change_factory do
    %NotificationChange{
      actor: build(:user)
    }
  end

  def notification_object_factory do
    %NotificationObject{
      entity_action: :create,
      entity: %{
        object_id: 1,
        object_type: :group,
        name: sequence("TravelGroup")
      },
      notification_change: build(:notification_change)
    }
  end

  def notification_factory do
    %Notification{
      notifier: build(:user),
      notification_object: build(:notification_object)
    }
  end

  def group_rating_factory do
    %GroupRating{
      author: build(:user),
      group: build(:group)
    }
  end
end
