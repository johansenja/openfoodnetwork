# frozen_string_literal: true

module Spree
  module Admin
    class ImagesController < ::Admin::ResourceController
      helper ::Admin::ProductsHelper

      # This will make resource controller redirect correctly after deleting product images.
      # This can be removed after upgrading to Spree 2.1.
      # See here https://github.com/spree/spree/commit/334a011d2b8e16355e4ae77ae07cd93f7cbc8fd1
      belongs_to 'spree/product'

      before_action :load_data

      def index
        @url_filters = ::ProductFilters.new.extract(request.query_parameters)
      end

      def new
        @url_filters = ::ProductFilters.new.extract(request.query_parameters)

        respond_with do |format|
          format.turbo_stream { render :edit }
          format.all { render layout: !request.xhr? }
        end
      end

      def edit
        @url_filters = ::ProductFilters.new.extract(request.query_parameters)
      end

      def create
        @url_filters = ::ProductFilters.new.extract(request.query_parameters)
        set_viewable

        @object.attributes = permitted_resource_params

        @object.save!
        flash[:success] = flash_message_for(@object, :successfully_created)

        redirect_to location_after_save
      rescue ActiveRecord::RecordInvalid => e
        respond_with_error(e)
      end

      def update
        @url_filters = ::ProductFilters.new.extract(request.query_parameters)
        set_viewable

        @object.update!(permitted_resource_params)
        flash[:success] = flash_message_for(@object, :successfully_updated)

        redirect_to location_after_save
      rescue ActiveRecord::RecordInvalid => e
        respond_with_error(e)
      end

      def destroy
        @url_filters = ::ProductFilters.new.extract(request.query_parameters)
        destroy_before

        if @object.destroy
          flash[:success] = flash_message_for(@object, :successfully_removed)
        end

        redirect_to location_after_save
      end

      private

      def collection
        parent.image
      end

      def find_resource
        parent.image
      end

      def build_resource
        Spree::Image.new(viewable: parent)
      end

      def location_after_save
        params[:return_url] || spree.admin_product_images_url(params[:product_id], @url_filters)
      end

      def load_data
        @product = Product.find(params[:product_id])
      end

      def set_viewable
        @image.viewable_type = 'Spree::Product'
        @image.viewable_id = params[:image][:viewable_id]
      end

      def destroy_before
        @viewable = @image.viewable
      end

      def permitted_resource_params
        params.require(:image).permit(
          :attachment, :viewable_id, :alt
        )
      end

      def respond_with_error(error)
        @errors = error.record.errors.map(&:full_message)
        respond_to do |format|
          format.html { respond_with(@object) }
          format.turbo_stream { render :edit }
        end
      end
    end
  end
end
