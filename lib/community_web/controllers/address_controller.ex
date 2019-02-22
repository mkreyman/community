defmodule CommunityWeb.AddressController do
  use CommunityWeb, :controller

  alias Community.Members
  alias Community.Members.Address

  plug :load_categories when action in [:new, :create, :edit, :update]

  defp load_categories(conn, _) do
    assign(conn, :categories, Address.categories())
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    addresses = Members.get_user_addresses!(current_user) 
    render(conn, "index.html", addresses: addresses)
  end

  def show(conn, %{"id" => id}, current_user) do
    address = Members.get_user_addresses!(current_user, id) 
    render(conn, "show.html", address: address)
  end

  def edit(conn, %{"id" => id}, current_user) do
    address = Members.get_user_addresses!(current_user, id) 
    changeset = Members.change_address(current_user, address)
    render(conn, "edit.html", address: address, changeset: changeset)
  end

  def update(conn, %{"id" => id, "address" => address_params}, current_user) do
    address = Members.get_user_addresses!(current_user, id) 

    case Members.update_address(address, address_params) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address updated successfully.")
        |> redirect(to: Routes.address_path(conn, :show, address))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", address: address, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    address = Members.get_user_addresses!(current_user, id) 
    {:ok, _address} = Members.delete_address(address)

    conn
    |> put_flash(:info, "Address deleted successfully.")
    |> redirect(to: Routes.address_path(conn, :index))
  end

  def new(conn, _params, current_user) do
    changeset = Members.change_address(current_user, %Address{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"address" => address_params}, current_user) do
    case Members.create_address(current_user, address_params) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address created successfully.")
        |> redirect(to: Routes.address_path(conn, :show, address))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end