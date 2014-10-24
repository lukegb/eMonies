require 'purchases_helper'

class PurchasesController < ApplicationController
  include SmartListing::Helper::ControllerExtensions
  helper SmartListing::Helper

  before_action :authenticate_person!

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = smart_listing_create :purchases, Purchase.includes(:acceptances).all, partial: "purchases/list", default_sort: {date: "asc"}, per_page: 10

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchases }
      format.js # index.js.erb
    end
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
    @purchase = Purchase.find(params[:id])
    @my_acceptance = @purchase.acceptances.where("person_id = ?", current_person.id)[0]
    if @my_acceptance.nil? then
      @my_acceptance = @purchase.acceptances.new
      @my_acceptance.person = current_person
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase }
    end
  end

  # GET /purchases/new
  # GET /purchases/new.json
  def new
    @purchase = Purchase.new
    @purchase.person_id = current_person.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase }
    end
  end

  # GET /purchases/1/edit
  def edit
    @purchase = Purchase.find(params[:id])
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        PurchasesHelper.recalculate_owes!

        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render json: @purchase, status: :created, location: @purchase }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchases/1
  # PUT /purchases/1.json
  def update
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      if @purchase.person == current_person && @purchase.update_attributes(purchase_params)
        PurchasesHelper.recalculate_owes!

        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase = Purchase.find(params[:id])

    if @purchase.person == current_person then
      @purchase.destroy
      PurchasesHelper.recalculate_owes!

      respond_to do |format|
        format.html { redirect_to purchases_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to purchases_url, :flash => { :error => "Can't delete another users purchases" }}
        format.json { head :no_content }
      end
    end
  end

  private
  def purchase_params
    params.require(:purchase).permit(:name, :amount, :description, :date, :person_id)
  end
end
