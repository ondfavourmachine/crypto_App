import 'package:crypto_app/blocs/crypto/crypto_bloc.dart';
import 'package:crypto_app/blocs/crypto/crypto_event.dart';
import 'package:crypto_app/blocs/crypto/crypto_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController? _scrollController;

  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Top Coins'),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).primaryColor,
                  Colors.grey[900]!,
                ])),
            child:
                BlocBuilder<CryptoBloc, CryptoState>(builder: (context, state) {
              switch (state.status) {
                case CryptoStatus.loaded:
                  return RefreshIndicator(
                      color: Theme.of(context).accentColor,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) =>
                            _onScrollNotification(notification),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.coins.length,
                          itemBuilder: (BuildContext context, int index) {
                            final coin = state.coins[index];
                            return ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              title: Text(
                                '${coin.fullName}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                coin.name as String,
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: Text(
                                '\$${coin.price.toStringAsFixed(4)}',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            );
                          },
                        ),
                      ),
                      onRefresh: () async {
                        context.read<CryptoBloc>().add(RefreshCoins());
                      });
                case CryptoStatus.error:
                  return Center(
                    child: Text(
                      state.failure.message,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                default:
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Theme.of(context).accentColor),
                    ),
                  );
              }
            })));
  }

  bool _onScrollNotification(ScrollNotification notif) {
    if (notif is ScrollEndNotification &&
        _scrollController!.position.extentAfter == 0) {
      context.read<CryptoBloc>().add(LoadMoreCoins());
    }
    return false;
  }
}
