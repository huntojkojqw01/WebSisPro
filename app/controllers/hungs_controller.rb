class HungsController < ApplicationController
  before_action :set_hung, only: [:show, :edit, :update, :destroy]

  # GET /hungs
  # GET /hungs.json
  def index
    @hungs = Hung.all
    @hung=Hung.new
  end

  # GET /hungs/1
  # GET /hungs/1.json
  def show
  end

  # GET /hungs/new
  def new
    @hung = Hung.new
  end

  # GET /hungs/1/edit
  def edit
  end

  # POST /hungs
  # POST /hungs.json
  def create
    @hung = Hung.new(hung_params)

    respond_to do |format|
      if @hung.save
        format.html { redirect_to @hung, notice: 'Hung was successfully created.' }
        format.js   {}
        format.json { render :show, status: :created, location: @hung }
      else
        format.html { render :new }
        format.json { render json: @hung.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hungs/1
  # PATCH/PUT /hungs/1.json
  def update
    respond_to do |format|
      if @hung.update(hung_params)
        format.html { redirect_to @hung, notice: 'Hung was successfully updated.' }
        format.json { render :show, status: :ok, location: @hung }
      else
        format.html { render :edit }
        format.json { render json: @hung.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hungs/1
  # DELETE /hungs/1.json
  def destroy
    @hung.destroy
    respond_to do |format|
      format.html { redirect_to hungs_url, notice: 'Hung was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hung
      @hung = Hung.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hung_params
      params.fetch(:hung, {})
    end
end
