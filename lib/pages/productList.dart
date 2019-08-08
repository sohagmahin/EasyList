import 'package:flutter/material.dart';
import './product_edit.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/products.dart';

class ProductListPage extends StatelessWidget {

  Widget _buildEditIconButton(BuildContext context, int index, ProductsModel model) {
        
        return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            model.selectProduct(index);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ProductEditPage(),
              ),
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.products[index].title),
              background: Container(
                color: Colors.red,
                child: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.delete,
                      size: 32.0,
                    )),
              ),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(index);
                  model.deleteProduct();
                }
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(model.products[index].image),
                    ),
                    subtitle: Text('\$${model.products[index].price.toString()}'),
                    title: Text(model.products[index].title),
                    trailing: _buildEditIconButton(context, index,model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.products.length,
        );
      },
    );
  }
}
