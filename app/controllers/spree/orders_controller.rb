module Spree
  class OrdersController < Spree::StoreController
    before_action :check_authorization
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/products', 'spree/orders'

    respond_to :html

    before_action :assign_order_with_lock, only: :update
    skip_before_action :verify_authenticity_token, only: [:populate]


    def change
      render json: "chao"
    end
    def show
      @order = Order.includes(line_items: [variant: [:option_values, :images, :product]], bill_address: :state, ship_address: :state).find_by_number!(params[:id])
    end

    def update
      if @order.contents.update_cart(order_params)
        respond_with(@order) do |format|
          format.html do
            if params.has_key?(:checkout)
              @order.next if @order.cart?
              redirect_to checkout_state_path(@order.checkout_steps.first)
            else
              redirect_to cart_path
            end
          end
        end
      else
        respond_with(@order)
      end
    end

    # Shows the current incomplete order from the session
    def edit
      @order = current_order || Order.incomplete.
                                  includes(line_items: [variant: [:images, :option_values, :product]]).
                                  find_or_initialize_by(guest_token: cookies.signed[:guest_token])
      associate_user
    end

    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      order    = current_order(create_order_if_necessary: true)
      variant  = Spree::Variant.find(params[:variant_id])
      cantidad = params[:quantity].to_i
      options  = params[:options] || {}
      sku = params[:product_sku]
      direccion = params[:direccion]

    # Validaciones
      if cantidad.between?(1, 2_147_483_647)
        if cantidad > Bodega.checkStockTotal(sku)
          error = "No tenemos esa cantidad en stock"
        end
      else
        error = "Por favor, coloca una cantidad razonable"
      end

      if error
        flash[:error] = error
        redirect_back_or_default(spree.root_path)
      else

        #Enviar a página de pago

        #Crear Boleta
        paramsBill = RequestsFactura.new.crearBoleta(Cliente.find_by(grupo: 7)._idGrupo, "b2c", cantidad*precioDeSku(sku))
        boleta = Bill.new(paramsBill)
        boleta.direccion = direccion
        boleta.sku = sku.to_s
        boleta.cantidad = cantidad
        boleta.save

        #Redireccion a Sistema Pago
        urlOk='http%3A%2F%2Fintegra7.ing.puc.cl/spree/confirmarCompra/'<<boleta._id
        urlFail='http%3A%2F%2Fintegra7.ing.puc.cl/spree/errorCompra/'
        url = "http://integracion-2016-prod.herokuapp.com/web/pagoenlinea?callbackUrl="+urlOk+"&cancelUrl="+urlFail+"+&boletaId="+boleta._id
        redirect_to url
      end




      # render json: {cantidad: params[:quantity], 
      #   variant: params[:variant_id],
      #   sku: params[:product_sku],
      #   direccion: params[:direccion]}

      #PARA AGREGAR A CAMPO

      # order    = current_order(create_order_if_necessary: true)
      # variant  = Spree::Variant.find(params[:variant_id])
      # quantity = params[:quantity].to_i
      # options  = params[:options] || {}

      # # 2,147,483,647 is crazy. See issue #2695.
      # if quantity.between?(1, 2_147_483_647)
      #   begin
      #     order.contents.add(variant, quantity, options)
      #   rescue ActiveRecord::RecordInvalid => e
      #     error = e.record.errors.full_messages.join(", ")
      #   end
      # else
      #   error = Spree.t(:please_enter_reasonable_quantity)
      # end

      # if error
      #   flash[:error] = error
      #   redirect_back_or_default(spree.root_path)
      # else
      #   respond_with(order) do |format|
      #     format.html { redirect_to root_path }
      #     #format.html { redirect_to cart_path }
      #   end
      # end
    end

    def precioDeSku(sku)
      if sku=='1' || sku==1
        return 1159
      elsif sku=='10' || sku==10
        return  15718 
      elsif sku=='23'|| sku==23
        return 4294
      elsif sku=='39'|| sku==39
        return 1217
      end
    end

    def empty
      if @order = current_order
        @order.empty!
      end

      redirect_to spree.cart_path
    end

    def accurate_title
      if @order && @order.completed?
        Spree.t(:order_number, :number => @order.number)
      else
        Spree.t(:shopping_cart)
      end
    end

    def check_authorization
      order = Spree::Order.find_by_number(params[:id]) || current_order

      if order
        authorize! :edit, order, cookies.signed[:guest_token]
      else
        authorize! :create, Spree::Order
      end
    end

    private

      def order_params
        if params[:order]
          params[:order].permit(*permitted_order_attributes)
        else
          {}
        end
      end

      def assign_order_with_lock
        @order = current_order(lock: true)
        unless @order
          flash[:error] = Spree.t(:order_not_found)
          redirect_to root_path and return
        end
      end
  end
end
