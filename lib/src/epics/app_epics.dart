import 'package:moviesflutter/src/actions/get_movies.dart';
import 'package:moviesflutter/src/data/movies_api.dart';
import 'package:moviesflutter/src/models/app_state.dart';
import 'package:rxdart/rxdart.dart';

import 'package:redux_epics/redux_epics.dart';

class AppEpics {
  AppEpics(this._api);

  final MoviesApi _api;

  Epic<AppState> get epics {
    return combineEpics([
      TypedEpic<AppState, GetMovies>(getMovies),
    ]);
  }

  Stream<dynamic> getMovies(Stream<GetMovies> actions, EpicStore<AppState> store) {
    return actions //
        .flatMap((GetMovies action) => Stream<void>.value(null)
            .asyncMap((_) => _api.getMovies(store.state.page))
            .map<Object>((List<String> titles) => GetMoviesSuccessful(titles))
            .onErrorReturnWith((error, stackTrace) => GetMoviesError(error))
            .doOnData(action.result));
  }
}
