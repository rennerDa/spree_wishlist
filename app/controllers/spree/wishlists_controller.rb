class Spree::WishlistsController < Spree::StoreController
  helper 'spree/products'

  before_filter :find_wishlist, :only => [:destroy, :show, :update, :edit, :add_all_products_to_cart]

  respond_to :html
  respond_to :js, :only => [:update]

  def new
    @wishlist = Spree::Wishlist.new

    respond_with(@wishlist)
  end

  def index
    @wishlists = spree_current_user.wishlists

    respond_with(@wishlist)
  end

  def edit
    respond_with(@wishlist)
  end

  def update
    @wishlist.update_attributes wishlist_attributes

    respond_with(@wishlist)
  end

  def show
    respond_with(@wishlist)
  end

  def default
    @wishlist = spree_current_user.wishlist

    respond_with(@wishlist)do |format|
      format.html { render 'show' }
    end
  end

  def create
    @wishlist = Spree::Wishlist.new wishlist_attributes
    @wishlist.user = spree_current_user

    @wishlist.save
    respond_with(@wishlist)
  end

  def destroy
    @wishlist.destroy
    respond_with(@wishlist )do |format|
      format.html { redirect_to account_path }
    end
  end

  def add_all_products_to_cart
    populator = Spree::OrderPopulator.new(current_order(true), current_currency)
    @wishlist.wished_products.each do |wish|
      variant = wish.variant
      product = variant.product

      if populator.populate({:variants => {variant.id => 1}})
        current_order.ensure_updated_shipments
      else
        flash[:error] = populator.errors.full_messages.join(" ")
        redirect_to :back
      end
    end
    redirect_to cart_path
  end

  private

  def wishlist_attributes
    params.require(:wishlist).permit(:name, :is_default, :is_private)
  end

  # Isolate this method so it can be overwritten
  def find_wishlist
    @wishlist = Spree::Wishlist.find_by_access_hash(params[:id])
  end

end
