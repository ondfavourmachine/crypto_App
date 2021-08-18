import 'package:crypto_app/blocs/crypto/crypto_event.dart';
import 'package:crypto_app/blocs/crypto/crypto_state.dart';
import 'package:crypto_app/models/failure_model.dart';
import 'package:crypto_app/repositories/crypto_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//  a bloc is a class that extends the bloc package and must be provided two things
// : an event class in this case cryptoevent and
// : a state class in this case cryptostate
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository _cryptoRepository;

  // this bloc needs a repository and uses an initializer to set
  // an instance of the cryptoRepository class. it also and very
  // importantly needs to inherit a state, so we give it an initial state using the super syntax;

  CryptoBloc({required CryptoRepository cryptoRepository})
      : _cryptoRepository = cryptoRepository,
        super(CryptoState.initial());

  @override
  Stream<CryptoState> mapEventToState(CryptoEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is RefreshCoins) {
      yield* _getCoins();
    } else if (event is LoadMoreCoins) {
      yield* _mapLoadMoreCoinsToState();
    }
  }

  Stream<CryptoState> _getCoins({int page = 0}) async* {
    try {
      final coins = [
        if (page != 0) ...state.coins,
        ...await _cryptoRepository.getTopCoins(page: page)
      ];
      yield state.copyWith(coins: coins, status: CryptoStatus.loaded);
    } on Failure catch (e) {
      yield state.copyWith(failure: e, status: CryptoStatus.error);
    }
  }

  Stream<CryptoState> _mapAppStartedToState() async* {
    yield state.copyWith(status: CryptoStatus.loading);
    yield* _getCoins();
  }

  Stream<CryptoState> _mapLoadMoreCoinsToState() async* {
    final nextPage = state.coins.length ~/ CryptoRepository.perPage;
    yield* _getCoins(page: nextPage);
  }
}
