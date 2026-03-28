require "test_helper"

module Api
  module V1
    class ProductsControllerTest < ActionDispatch::IntegrationTest
      # === INDEX ===

      test "index retorna lista de produtos" do
        get api_v1_products_url
        assert_response :success

        json = JSON.parse(response.body)
        assert_kind_of Array, json
        assert_equal Product.count, json.size
      end

      # === SHOW ===

      test "show retorna produto específico" do
        product = products(:arroz_integral)
        get api_v1_product_url(product)
        assert_response :success

        json = JSON.parse(response.body)
        assert_equal product.name, json["name"]
      end

      test "show retorna 404 para produto inexistente" do
        get api_v1_product_url(id: 999999)
        assert_response :not_found

        json = JSON.parse(response.body)
        assert_equal "Produto não encontrado", json["error"]
      end

      # === CREATE ===

      test "create cria produto com dados válidos" do
        assert_difference("Product.count", 1) do
          post api_v1_products_url, params: {
            product: {
              name: "Suco de Laranja 1L",
              quantity: 40,
              price: 6.50,
              category: "Bebidas",
              brand: "Del Valle",
              expiration_date: "2027-01-15"
            }
          }
        end

        assert_response :created

        json = JSON.parse(response.body)
        assert_equal "Suco de Laranja 1L", json["name"]
        assert_equal 40, json["quantity"]
      end

      test "create rejeita produto com dados inválidos" do
        assert_no_difference("Product.count") do
          post api_v1_products_url, params: {
            product: {
              name: "",
              quantity: -1,
              price: nil,
              category: "",
              brand: ""
            }
          }
        end

        assert_response :unprocessable_entity

        json = JSON.parse(response.body)
        assert json["errors"].is_a?(Array)
        assert json["errors"].any?
      end

      test "create rejeita nome duplicado" do
        existing = products(:arroz_integral)

        assert_no_difference("Product.count") do
          post api_v1_products_url, params: {
            product: {
              name: existing.name,
              quantity: 10,
              price: 5.0,
              category: "Alimentos",
              brand: "Outra Marca"
            }
          }
        end

        assert_response :unprocessable_entity
      end

      # === UPDATE ===

      test "update atualiza produto com dados válidos" do
        product = products(:arroz_integral)

        patch api_v1_product_url(product), params: {
          product: { quantity: 999, price: 19.90 }
        }

        assert_response :success

        json = JSON.parse(response.body)
        assert_equal 999, json["quantity"]

        product.reload
        assert_equal 999, product.quantity
      end

      test "update rejeita dados inválidos" do
        product = products(:arroz_integral)

        patch api_v1_product_url(product), params: {
          product: { quantity: -5 }
        }

        assert_response :unprocessable_entity
      end

      # === DESTROY ===

      test "destroy remove produto" do
        product = products(:refrigerante_cola)

        assert_difference("Product.count", -1) do
          delete api_v1_product_url(product)
        end

        assert_response :no_content
      end
    end
  end
end
