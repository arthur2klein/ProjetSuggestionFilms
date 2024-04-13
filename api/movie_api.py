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

class Rating(BaseModel):
    user: str
    movie: str
    rating: float

def get_imdb_rating(movie_id: str) -> float:
    try:
        reviews = ia.get_movie_user_reviews(movie_id)
        if reviews:
            ratings = [review.data['rating'] for review in reviews]
            avg_rating = sum(ratings) / len(ratings)
            return avg_rating
        else:
            return 0.0
    except:
        return 0.0

@router.get("/")
async def movie(movie_id: str):
    try:
        movie = ia.get_movie(movie_id)
        movie_details = {
                'movieid': movie_id,
                'movietitle': movie.get('title', ''),
                'releasedate': movie.get('year', 0),
                'synopsis': movie.get('plot outline', ''),
                'director': ', '.join(sorted([d['name'] for d in movie.get('directors',[])])),
                'imgurl': movie.get('full-size cover url', ''),
                'usernote': get_imdb_rating(movie_id),
                'time': movie.get('runtimes', [0])[0] if movie.get('runtimes') else 0}
        return {'data': movie_details}
    except Exception:
        raise HTTPException(status_code=404, detail="Movie not found")

@router.get("/search")
async def search_movie(query: str = Query(..., min_length=1)):
    try:
        results = ia.search_movie(query, 10)
        movies = []
        for movie in results:
            movie_id = movie.movieID
            movies.append({
                'movieid': movie_id,
                'movietitle': movie.get('title', ''),
                'releasedate': movie.get('year', 0),
                'synopsis': movie.get('plot outline', ''),
                'director': ', '.join(sorted([d['name'] for d in movie.get('directors',[])])),
                'imgurl': movie.get('full-size cover url', ''),
                'usernote': get_imdb_rating(movie_id),
                'time': movie.get('runtimes', [0])[0] if movie.get('runtimes') else 0
                })
        return {'data': movies}
    except Exception:
        raise HTTPException(status_code=500, detail="IMDb data access error")

@router.get("/rating")
async def get_rating(user: str, movie: str):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "SELECT rating FROM rating WHERE user_id = %s AND movie_id = %s",
                (user, movie)
                )
        result = cursor.fetchone()
        if result:
            rating = result[0]
            return {"user": user, "movie": movie, "rating": rating}
        else:
            raise HTTPException(status_code=404, detail="Rating not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        conn.close()

@router.post("/rating")
async def rate_movie(rating: Rating):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "INSERT INTO rating (user_id, movie_id, rating) VALUES (%s, %s, %s)",
                (rating.user, rating.movie, rating.rating)
                )
        conn.commit()
        return {"message": "Rating recorded successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        conn.close()

@router.post("/view")
async def view_movie(view: View):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "INSERT INTO user_saw_movie (user_id, movie_id) VALUES (%s, %s)",
                (view.user, view.movie)
                )
        conn.commit()
        return {"message": "View recorded successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        conn.close()

@router.get("/seen")
async def has_seen_movie(user: str, movie: str):
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
                "SELECT * FROM user_saw_movie WHERE user_id = %s AND movie_id = %s",
                (user, movie)
                )
        result = cursor.fetchall()
        return {"data": 0 if result == [] else 1}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")
    finally:
        conn.close()

@router.get("/genres")
async def genres_movie(movie: str):
    try:
        imdb_movie = ia.get_movie(movie)
        genres = [genre.replace('_', ' ') for genre in imdb_movie.get('genres', [])]
        return {"data": genres}
    except Exception:
        raise HTTPException(status_code=404, detail="Movie not found")

