from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from user_api import router as user_router
from group_api import router as group_router
from movie_api import router as movie_router

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE"],
    allow_headers=["*"],
)

app.include_router(user_router, prefix="/user", tags=["users"])
app.include_router(group_router, prefix="/group", tags=["groups"])
app.include_router(movie_router, prefix="/movie", tags=["movies"])
