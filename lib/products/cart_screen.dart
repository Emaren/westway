import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);

    String createMailBody() {
      var body = 'Here are the items in my cart:\n';

      for (var product in cart.products) {
        body += '${product.name} - \$${product.price.toStringAsFixed(2)}\n';
      }

      body += '\nTotal: \$${cart.totalPrice.toStringAsFixed(2)}';

      return body;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: FittedBox(
                          child: Text(
                              '\$${cart.products[index].price.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    title: Text(cart.products[index].name),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        cart.remove(cart.products[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleLarge!
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    ElevatedButton(
                      child: const Text('Order Now'),
                      onPressed: () async {
                        String subject = Uri.encodeComponent('Place Order');
                        String body = Uri.encodeComponent(createMailBody());
                        String emailUriStr =
                            'mailto:tony@emaren.ca?subject=$subject&body=$body';

                        if (await canLaunch(emailUriStr)) {
                          await launch(emailUriStr);
                        } else {
                          throw 'Could not launch $emailUriStr';
                        }
                      },
                    ),
                  ],
                ),
              ))
        ]));
  }
}
