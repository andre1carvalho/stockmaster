class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :price, :category, :brand, :expiration_date, :created_at, :updated_at

  # Formata price com 2 casas decimais (12.9 → "12.90")
  def price
    "%.2f" % object.price
  end

  # Formata data como "YYYY-MM-DD" ou retorna nil
  def expiration_date
    object.expiration_date&.strftime("%Y-%m-%d")
  end
end
