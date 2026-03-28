require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # === Produto válido ===

  test "produto válido salva com sucesso" do
    product = Product.new(
      name: "Café Pilão 500g",
      quantity: 30,
      price: 15.90,
      category: "Alimentos",
      brand: "Pilão"
    )
    assert product.valid?
  end

  # === Validações de name ===

  test "name é obrigatório" do
    product = Product.new(name: nil, quantity: 10, price: 5.0, category: "Bebidas", brand: "Marca")
    assert_not product.valid?
    assert_includes product.errors[:name], "não pode ficar em branco"
  end

  test "name deve ser único (case-insensitive)" do
    product = Product.new(
      name: products(:arroz_integral).name.upcase,
      quantity: 10,
      price: 5.0,
      category: "Alimentos",
      brand: "Outra Marca"
    )
    assert_not product.valid?
    assert_includes product.errors[:name], "já está em uso"
  end

  # === Validações de quantity ===

  test "quantity é obrigatório" do
    product = Product.new(name: "Teste", quantity: nil, price: 5.0, category: "Geral", brand: "Marca")
    assert_not product.valid?
    assert_includes product.errors[:quantity], "não pode ficar em branco"
  end

  test "quantity deve ser inteiro" do
    product = Product.new(name: "Teste", quantity: 2.5, price: 5.0, category: "Geral", brand: "Marca")
    assert_not product.valid?
    assert_includes product.errors[:quantity], "não é um número inteiro"
  end

  test "quantity não pode ser negativo" do
    product = Product.new(name: "Teste", quantity: -1, price: 5.0, category: "Geral", brand: "Marca")
    assert_not product.valid?
    assert_includes product.errors[:quantity], "deve ser maior ou igual a 0"
  end

  test "quantity zero é válido" do
    product = Product.new(name: "Sem Estoque", quantity: 0, price: 5.0, category: "Geral", brand: "Marca")
    assert product.valid?
  end

  # === Validações de price ===

  test "price é obrigatório" do
    product = Product.new(name: "Teste", quantity: 10, price: nil, category: "Geral", brand: "Marca")
    assert_not product.valid?
    assert_includes product.errors[:price], "não pode ficar em branco"
  end

  test "price não pode ser negativo" do
    product = Product.new(name: "Teste", quantity: 10, price: -1.0, category: "Geral", brand: "Marca")
    assert_not product.valid?
    assert_includes product.errors[:price], "deve ser maior ou igual a 0"
  end

  test "price zero é válido" do
    product = Product.new(name: "Brinde", quantity: 5, price: 0, category: "Promoção", brand: "Marca")
    assert product.valid?
  end

  # === Validações de category ===

  test "category é obrigatório" do
    product = Product.new(name: "Teste", quantity: 10, price: 5.0, category: nil, brand: "Marca")
    assert_not product.valid?
    assert_includes product.errors[:category], "não pode ficar em branco"
  end

  # === Validações de brand ===

  test "brand é obrigatório" do
    product = Product.new(name: "Teste", quantity: 10, price: 5.0, category: "Geral", brand: nil)
    assert_not product.valid?
    assert_includes product.errors[:brand], "não pode ficar em branco"
  end
end
