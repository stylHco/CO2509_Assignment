
// API constants
const String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNjAwMDFjNGM1MzZlMjlmMzBhNmExNDBlYWUzOTEwNSIsInN1YiI6IjY1YjExYjNmZGQ5MjZhMDE1MjRkMDMzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ICnU5fWhhlyM9OSZFr_H4S73J2M_W-Y7gd5K62GC3tM';
const  headers = {
'accept': 'application/json',
'Authorization': 'Bearer $apiKey',
};

const String defaultStringForApiCalls = 'https://api.themoviedb.org/3';

// API URLs

const String playingNowMoviesURL = '$defaultStringForApiCalls/movie/now_playing';
const String topRatedMoviesURL = '$defaultStringForApiCalls/movie/top_rated';
const String upcomingMoviesURL = '$defaultStringForApiCalls/movie/upcoming';
const String playingNowTVSeriesURL = '$defaultStringForApiCalls/tv/airing_today';
const String popularTVSeriesURL = '$defaultStringForApiCalls/tv/popular';
const String topRatedTVSeriesURL = '$defaultStringForApiCalls/tv/top_rated';


// images paths
const String backdropPathURL = "https://image.tmdb.org/t/p/w500";
const String logoUrl = "Resources/images/api_logo.png";

