import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/title_Default.dart';
import './address_tag.dart';
import '../../models/product.dart';

import 'package:scoped_model/scoped_model.dart';
import '../../scoped-model/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;
  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
        padding: EdgeInsets.only(
          top: 10.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title), //This widget display title of product
            SizedBox(
              width: 8.0,
            ),
            PriceTag(product.price.toString()),
          ],
        ));
  }

  Widget _buildActionBar(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator.pushNamed<bool>(
                      //For generating string then we pass some info of our product.
                      context, '/product/' +model.allproducts[productIndex].id,
                    )),
            IconButton(
              icon: Icon(model.allproducts[productIndex].isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                model.selectProduct(model.allproducts[productIndex].id);
                model.toggleProductFavoriteStatus();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300,
            fit: BoxFit.cover,
            placeholder: AssetImage("assets/food.jpg"),
          ),
          _buildTitlePriceRow(),
          AddressTag('Union Square, San Francisco'),
          Text(product.userEmail),
          _buildActionBar(context)
        ],
      ),
    );
  }
}
