from fastapi import APIRouter, HTTPException, Query
from typing import List
from imdb import Cinemagoer
from pydantic import BaseModel
from db import get_db_connection

router = APIRouter()

ia = Cinemagoer()

class Movie(BaseModel):
    movieid: str
    movietitle: str
    releasedate: int
    synopsis: str
    director: str
    imgurl: str
    usernote: float
    time: int

class View(BaseModel):
    user: str
    movie: str
    hasSeen: str

class Rating(BaseModel):
    user: str
    movie: str
    rating: float

def get_imdb_rating(movie_id: str) -> float:
    try:
        reviews = ia.get_movie_reviews(movie_id)['data']['reviews']
        if reviews:
            ratings = [review['rating'] for review in reviews if review['rating'] != None]
            avg_rating = sum(ratings) / len(ratings)
            return round(avg_rating, 2)
        else:
            return 0.0
    except:
        return 0.0

def get_infos_movie(movie):
    ia.update(movie)
    movie_id = movie.movieID
    return {
            'movieid': movie_id,
            'movietitle': movie.get('title', ''),
            'releasedate': movie.get('year', 0),
            'synopsis': '\n'.join(movie.get('synopsis', [])),
            'director': ', '.join(
                director.get('name', '')
                for director in movie.get('director','')
                ),
            'imgurl': movie.get('full-size cover url', ''),
            'usernote': get_imdb_rating(movie_id),
            'time': movie.get('runtimes', ['0'])[0]}

@router.get("/")
async def movie(movie_id: str):
    try:
        movie = ia.get_movie(movie_id)
        return {'data': get_infos_movie(movie)}
    except Exception:
        raise HTTPException(status_code=404, detail="Movie not found")

@router.get("/search")
async def search_movie(query: str = Query(..., min_length=1)):
    try:
        results = ia.search_movie(query, 5)
        movies = []
        for movie in results:
            movies.append(get_infos_movie(movie))
        return {'data': movies}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"IMDb data access error: {str(e)}")

def get_rating(user: str, movie: str):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "SELECT rating FROM rating "
                "WHERE user_id = %s AND movie_id = %s",
                (user, movie)
                )
        result = cursor.fetchone()
        if result:
            rating = result[0]
            return {"user": user, "movie": movie, "rating": rating}
        else:
            raise HTTPException(status_code=404, detail="Rating not found")
    except Exception as e:
        raise HTTPException(
                status_code=500,
                detail=f"Database error: {str(e)}"
                )
    finally:
        conn.close()

@router.get("/rating")
async def get_rating_resource(user: str, movie: str):
    return get_rating(user, movie)

@router.post("/rating")
async def rate_movie(rating: Rating):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "UPDATE rating SET rating=%s WHERE user_id=%s AND movie_id=%s",
                (rating.rating, rating.user, rating.movie)
                )
        num_rows_changed = cursor.rowcount
        if (num_rows_changed == 0):
            raise Exception("No rating yet")
        conn.commit()
        return {"message": "Rating changed successfully"}
    except Exception as e:
        conn.rollback()
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "INSERT INTO rating (user_id, movie_id, rating) "
                "VALUES (%s, %s, %s)",
                (rating.user, rating.movie, rating.rating)
                )
        conn.commit()
        return {"message": "Rating recorded successfully"}
    except Exception as e:
        raise HTTPException(
                status_code=500,
                detail=f"Database error: {str(e)}"
                )
    finally:
        conn.close()

def add_view(view: View):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "INSERT INTO user_saw_movie (user_id, movie_id) "
                "VALUES (%s, %s)",
                (view.user, view.movie)
                )
        conn.commit()
        return {"message": "View recorded successfully"}
    except Exception as e:
        raise HTTPException(
                status_code=500,
                detail=f"Database error: {str(e)}"
                )
    finally:
        conn.close()

def remove_view(view: View):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "DELETE FROM user_saw_movie "
                "WHERE user_id=%s AND movie_id=%s",
                (view.user, view.movie)
                )
        conn.commit()
        return {"message": "View removed successfully"}
    except Exception as e:
        raise HTTPException(
                status_code=500,
                detail=f"Database error: {str(e)}"
                )
    finally:
        conn.close()

@router.post("/view")
async def view_movie(view: View):
    if view.hasSeen == '1':
        return add_view(view)
    else:
        return remove_view(view)

@router.get("/seen")
async def has_seen_movie(user: str, movie: str):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "SELECT * FROM user_saw_movie "
                "WHERE user_id = %s AND movie_id = %s",
                (user, movie)
                )
        result = cursor.fetchall()
        return {"data": 0 if result == [] else 1}
    except Exception as e:
        raise HTTPException(
                status_code=500,
                detail=f"Database error: {str(e)}"
                )
    finally:
        conn.close()

def get_genres(movie: str):
    imdb_movie = ia.get_movie(movie)
    ia.update(imdb_movie)
    return [genre.replace('_', ' ') for genre in imdb_movie.get('genres', [])]

@router.get("/genres")
async def genres_movie(movie: str):
    try:
        genres = get_genres(movie)
        return {"data": genres}
    except Exception:
        raise HTTPException(status_code=404, detail="Movie not found")

def get_pref_user(user: str):
    sum_by_genre = dict()
    num_by_genre = dict()
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "SELECT movie_id, rating FROM rating WHERE user_id=%s",
                (user)
                )
        result = cursor.fetchall()
        print(f'Movies collected: {result=}')
        for movie, rating in result:
            print('Examining the next movie')
            print('Reading genres')
            genres = get_genres(movie)
            print('Adding to the average')
            for genre in genres:
                print(f'Adding to the sum for {genre=}')
                sum_by_genre[genre] = sum_by_genre.get(genre, 0.) + rating
                num_by_genre[genre] = num_by_genre.get(genre, 0) + 1
        print('Returning')
        return {
                key: sum_by_genre[key] / num_by_genre[key]
                for key in sum_by_genre.keys()
                }
    except Exception as e:
        raise HTTPException(
                status_code=500,
                detail=f"Error while calculating score for user {user}: "
                f"{str(e)}"
                )

def get_prefs_group(users: [str]):
    return [get_pref_user(user) for user in users]

def get_keys_dicts(list_dict):
    return {key for dict_ in list_dict for key in dict_.keys()}

def get_pref_group(users: [str]):
    sum_by_genre = dict()
    num_user = len(users)
    list_prefs = get_prefs_group(users)
    return {
            genre: sum(
                pref_user.get(genre, 2.)
                for pref_user in list_prefs
                ) / num_user
            for genre in get_keys_dicts(list_prefs)
            }

def score_movies_for_group(users: [str], movies: [str]):
    score = dict()
    pref = get_pref_group(users)
    for movie in movies:
        genres_movie = get_genres(movie.movieID)
        if (len(genres_movie) == 0):
            score[movie] = 2.
        else:
            score[movie] = sum(
                    pref.get(genre, 2.)
                    for genre in genres_movie
                    ) / len(genres_movie)
    return score

def movies_for_recommendations():
    return ia.search_movie('t', 128)

@router.get("/recommended")
async def recommended_for_user(users: list[str] = Query(..., title="User IDs")):
    dict_ = score_movies_for_group(users, movies_for_recommendations())
    recommendations = sorted(dict_, key=dict_.get)
    recommendations.reverse()
    return {
            "data":
            [
                get_infos_movie(movie)
                for movie in recommendations[:10]
                ]
            }
