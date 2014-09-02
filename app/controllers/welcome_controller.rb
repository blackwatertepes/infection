class WelcomeController < ApplicationController
  def index
    @NODE_INFECTION_RATE = params['NODE_INFECTION_RATE'] || 0.002
    @NODE_CANCER_RATE = params['NODE_CANCER_RATE'] || 0.01
    @NODE_INFECTION_REDUCTION = params['NODE_INFECTION_REDUCTION'] || 10.0
    @EDGE_SPEED = params['EDGE_SPEED'] || 1.0
    @EDGE_SPEED_MULTI = params['EDGE_SPEED_MULTI'] || 0.5
  end
end
