class CartsController < ApplicationController
  before_action :set_cart

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end



  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to store_url }
      format.json { head :no_content }
    end
  end

  def enviar
    @cart = Cart.find(params[:id])
    @aux = @cart
    mail = params[:mail]
    Mailer.Order(@aux).deliver
    Mailer.Confirmation(mail, @aux).deliver
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { 

      }
      format.json { head :no_content }
    end
  end  

  def add_cartucho
    @cart.save
    session[:cart_id] = @cart.id
    product = Cartucho.find(params[:id])
    item = @cart.make_items(@cart.id, product.id, 1)
    @cart.total_price

    flash[:notice] = "Product Added to Cart"
    redirect_to cartuchos_path
  end

  private
  def start_session!
    if !session[:cart_id].nil?
      set_cart
    end
    session[:cart_id].nil?
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    if session[:cart_id].nil?
      @cart = Cart.create
      session[:cart_id]=@cart.id
      @cart
    else
      @cart=Cart.find(session[:cart_id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cart_params
    params[:cart_id]
  end
end
