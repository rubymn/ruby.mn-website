class BearddexesController < ApplicationController
  def show
    @beardos = User.beardos
    @bearddex = User.calc_bdx
  end
end
