class CountriesController < ApplicationController
  def index
    @q = Country.ransack(params[:q])
    @countries = @q.result(:distinct => true).includes(:activities, :favorites).page(params[:page]).per(10)

    render("countries/index.html.erb")
  end

  def show
    @activity = Activity.new
    @country = Country.find(params[:id])

    render("countries/show.html.erb")
  end

  def new
    @country = Country.new

    render("countries/new.html.erb")
  end

  def create
    @country = Country.new

    @country.name = params[:name]
    @country.flag = params[:flag]

    save_status = @country.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/countries/new", "/create_country"
        redirect_to("/countries")
      else
        redirect_back(:fallback_location => "/", :notice => "Country created successfully.")
      end
    else
      render("countries/new.html.erb")
    end
  end

  def edit
    @country = Country.find(params[:id])

    render("countries/edit.html.erb")
  end

  def update
    @country = Country.find(params[:id])

    @country.name = params[:name]
    @country.flag = params[:flag]

    save_status = @country.save

    if save_status == true
      referer = URI(request.referer).path

      case referer
      when "/countries/#{@country.id}/edit", "/update_country"
        redirect_to("/countries/#{@country.id}", :notice => "Country updated successfully.")
      else
        redirect_back(:fallback_location => "/", :notice => "Country updated successfully.")
      end
    else
      render("countries/edit.html.erb")
    end
  end

  def destroy
    @country = Country.find(params[:id])

    @country.destroy

    if URI(request.referer).path == "/countries/#{@country.id}"
      redirect_to("/", :notice => "Country deleted.")
    else
      redirect_back(:fallback_location => "/", :notice => "Country deleted.")
    end
  end
end
