class Current < ActiveSupport::CurrentAttributes
  include Project8Constants

  attribute :user
  attribute :default_lat, :float
  attribute :default_lng, :float
  attribute :params_lat, :float
  attribute :params_lng, :float
  attribute :default_radius, :float
  attribute :params_radius, :float
  attribute :lat, :float
  attribute :lng, :float
  # attribute :radius, :float
  # attribute :params_coords

  # declare global constants
  # attribute :INFINIINFINITY_RADIUS, :float # in meters
  # attribute :APP_DEFAULT_LAT, :float
  # attribute :APP_DEFAULT_LNG, :float

  # MAX_RADIUS = 30000000.0 # in meters
  # APP_DEFAULT_LAT = 0.0
  # APP_DEFAULT_LNG = 0.0

  def set_user=(u)
    self.user = u
    # puts self.user.inspect
  end

  def default_coords=(user)
    # super
    self.default_lat = user.default_lat.to_f
    self.default_lng = user.default_lng.to_f

    # NOTE default_lat/lng must be required an have at least a default and valid value
    self.lat = self.default_lat
    self.lng = self.default_lng
    self.default_radius = MAX_RADIUS
    # self.radius = MAX_RADIUS

    # puts "BEGIN DEBUG default_coords=(user)"
    # puts self.default_lat
    # puts self.default_lng
    # puts self.radius
    # puts "Current.lat/lng"
    # puts self.lat
    # puts self.lng
    # puts "END DEBUG default_coords=(user)"

  end

  def params_coords=(coords)
    if coords.present? then
      self.params_lat = coords[:lat].to_f
      self.params_lng = coords[:lng].to_f

      # if coords exist and are valid, ...
      # ... Current lat/lng gets assigned these values instead of user defaults/lat/lng
      self.lat = self.params_lat
      self.lng = self.params_lng

      # puts "BEGIN DEBUG params_coords=(params)"
      # puts self.params_lat
      # puts self.params_lng
      # puts "Current.lat/lng"
      # puts self.lat
      # puts self.lng
      # puts "END DEBUG params_coords=(params)"
    else
      self.params_lat = APP_DEFAULT_LAT
      self.params_lng = APP_DEFAULT_LNG

      # puts "BEGIN DEBUG params_coords=(params) APP_DEFAULT"
      # puts self.params_lat
      # puts self.params_lng
      # puts "END DEBUG params_coords=(params) APP_DEFAULT"
    end
  end

  def radius=(r)
    # if params.present? && params[:task].present? && params[:task][:radius].present? then
    if r.present? then
      self.params_radius = r
      # self.radius = r

      # puts "DEBUG radius=(params)"
      # puts self.params_radius
    else
      self.params_radius = MAX_RADIUS

      # puts "DEBUG radius=(params) INFINITY RADIUS"
      # puts self.params_radius
    end
  end

  def radius
    self.params_radius || self.default_radius #MAX_RADIUS
  end
end