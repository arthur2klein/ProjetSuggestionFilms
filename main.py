from fastapi import FastAPI, HTTPException, Query
from sqlalchemy import create_engine, Column, Integer, String, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from typing import List, Optional

# Initialiser FastAPI
app = FastAPI()

# Connexion à la base de données MySQL
SQLALCHEMY_DATABASE_URL = "mysql+pymysql://utilisateur:lesfilmscestbien@localhost/movie_streaming_db"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Déclarer la base pour la déclaration des modèles
Base = declarative_base()

# Définir le modèle SQLAlchemy pour la table des films
class Movie(Base):
    __tablename__ = "movies"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    year = Column(Integer)
    director = Column(String)
    genre = Column(String)
    rating = Column(Float)

# Définir le modèle SQLAlchemy pour la table des utilisateurs
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, index=True)
    email = Column(String, index=True)
    age = Column(Integer, nullable=True)

# Routes pour les films (movies)
@app.get("/movies/", response_model=List[Movie])
def get_movies():
    db = SessionLocal()
    movies = db.query(Movie).all()
    db.close()
    return movies

@app.get("/movies/{movie_id}", response_model=Movie)
def get_movie(movie_id: int):
    db = SessionLocal()
    movie = db.query(Movie).filter(Movie.id == movie_id).first()
    db.close()
    if movie is None:
        raise HTTPException(status_code=404, detail="Movie not found")
    return movie

@app.get("/movies/search", response_model=List[Movie])
def search_movies(title: Optional[str] = None, director: Optional[str] = None, year: Optional[int] = None):
    db = SessionLocal()
    query = db.query(Movie)
    if title:
        query = query.filter(Movie.title.ilike(f"%{title}%"))
    if director:
        query = query.filter(Movie.director.ilike(f"%{director}%"))
    if year:
        query = query.filter(Movie.year == year)
    movies = query.all()
    db.close()
    return movies

@app.get("/movies/rating", response_model=List[Movie])
def get_movies_with_rating(min_rating: float = Query(..., gt=0, le=10)):
    db = SessionLocal()
    movies = db.query(Movie).filter(Movie.rating >= min_rating).all()
    db.close()
    return movies

@app.get("/movies/genres", response_model=List[str])
def get_movie_genres():
    db = SessionLocal()
    genres = db.query(Movie.genre).distinct().all()
    db.close()
    return [genre[0] for genre in genres]

# Routes pour les utilisateurs (users)
@app.get("/users/", response_model=List[User])
def get_users():
    db = SessionLocal()
    users = db.query(User).all()
    db.close()
    return users

@app.get("/users/{user_id}", response_model=User)
def get_user(user_id: int):
    db = SessionLocal()
    user = db.query(User).filter(User.id == user_id).first()
    db.close()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.get("/users/{user_id}/movies", response_model=List[Movie])
def get_user_movies(user_id: int):
    db = SessionLocal()
    # Juste un exemple de requête, vous devrez adapter cela selon votre structure de données réelle.
    user_movies = db.query(Movie).filter(Movie.id == user_id).all()
    db.close()
    return user_movies
