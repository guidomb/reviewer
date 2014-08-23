module ModulesHelper

  def implementor(mod)
    Class.new { include mod }.new
  end

end