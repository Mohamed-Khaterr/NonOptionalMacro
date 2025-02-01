//
//  ProductsScreen.swift
//  Example
//
//  Created by Mohamed Khater on 29/01/2025.
//

import SwiftUI

struct ProductsScreen: View {
    @State var products: [Product] = []
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(products) { product in
                    HStack {
                        AsyncImage(url: product.imageURL) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } else {
                                ProgressView()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(product.title)
                            Text(product.brand)
                            Text(product.meta.barcode)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal)
        }
        .task {
            await fetchProducts()
        }
    }
    
    @MainActor
    func fetchProducts() async {
        do {
            let urlRequest = URLRequest(url: URL(string: "https://dummyjson.com/products")!)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let response = try JSONDecoder().decode(Products.self, from: data)
            products = response.products
            for product in response.products {
                print("----------")
                print(product.title, product.brand)
                print("isBrandEmpty:", product.brand.isEmpty)
                print("----------")
            }
        } catch {
            print(error)
        }
    }
}
