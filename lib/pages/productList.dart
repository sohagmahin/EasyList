import 'package:flutter/material.dart';
import './product_edit.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';

class ProductListPage extends StatelessWidget {

  Widget _buildEditIconButton(BuildContext context, int index, MainModel model) {
        
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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
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
                      backgroundImage: AssetImage(model.allproducts[index].image),
                    ),
                    subtitle: Text('\$${model.allproducts[index].price.toString()}'),
                    title: Text(model.allproducts[index].title),
                    trailing: _buildEditIconButton(context, index,model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allproducts.length,
        );
      },
    );
  }
}
