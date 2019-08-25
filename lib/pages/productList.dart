import 'package:flutter/material.dart';
import './product_edit.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;
  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
   
    return _ProductListPageState();
  }
}
class _ProductListPageState extends State<ProductListPage>{
  @override
  initState(){
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildEditIconButton(BuildContext context, int index, MainModel model) {
        
        return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            model.selectProduct(model.allproducts[index].id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ProductEditPage(),
              ),
            ).then((_){
              model.selectProduct(null);
            });
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
              key: Key(model.allproducts[index].title),
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
                  model.selectProduct(model.allproducts[index].id);
                  model.deleteProduct();
                }
              },
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(model.allproducts[index].image),
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
